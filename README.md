# yeet template

This is a template for creating a new BPF program for loading with yeet.

## Usage

```sh
make init
```

This will create a new directory with the name you provided, copy the template into it, and initialize a git repository.

To get started, run `make` to build the BPF program.

```sh
make -C <name>
```

This will build the BPF program in a docker container. If you do not have docker installed, you can build the program natively with `CONTAINER=no make -C <name>` but you will need to have the necessary tooling installed.

## Loading the BPF program

To load the BPF program, use yeet.

```sh
sudo yeet add path/to/<name>
sudo yeet start <name>
```

This will load the BPF program and start it. You can then check the status of the BPF program with `sudo yeet ls`.

You can also view the output of bpf_printk statements with

```
sudo yeet trace
```

NOTE: In order to load properly, the BPF program must pass the verifier.

To view logs from yeetd, use

```sh
sudo journalctl -u yeetd.service -f
```