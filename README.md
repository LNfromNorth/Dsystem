# Versions

- qemu: 7.2.21
- linux: 5.15.196

# How to use

1. Prepare software source code: you need to run `prepare.sh` to download the source code of qemu and linux.

```
# download qemu, linux
./prepare.sh
```

2. Build them: type make to build them. (Now only support build x86_64 in scripts)
```
# Build qemu, linux
make
```

3. Start your own work: use command below you can debug with what you want to know.
```
# run vm
make run

# debug qemu (hardware)
make dqemu

# debug linux (software: OS)
make dlinux
```
