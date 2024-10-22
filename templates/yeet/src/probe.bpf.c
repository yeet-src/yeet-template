#include <vmlinux.h>
#include <bpf/bpf_helpers.h>
#include <yeet/yeet.h>

struct output {
  int pid;
} __attribute__((packed));

RINGBUF_CHANNEL(output_rb, 1024 * sizeof(struct output), output);

SEC("tracepoint/syscalls/sys_enter_execve")
int trace_sys_execve(struct trace_event_raw_sys_enter *ctx)
{
  struct output *cmd = bpf_ringbuf_reserve(&output_rb, sizeof(struct output), 0);
  int pid = bpf_get_current_pid_tgid() >> 32;

  if (!cmd) {
    return 0;
  }

  cmd->pid = pid;
  bpf_ringbuf_submit(cmd, 0);

  return 0;
}

char LICENSE[] SEC("license") = "Dual BSD/GPL";