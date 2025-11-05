FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \
    bison build-essential cmake flex git libedit-dev \
    libllvm14 llvm-14-dev libclang-14-dev python3 zlib1g-dev \
    libelf-dev libfl-dev python3-distutils python3-setuptools \
    zip ca-certificates wget gnupg2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/ubuntu

# Build and install BCC
RUN git clone https://github.com/iovisor/bcc.git /home/ubuntu/bcc && \
    mkdir -p /home/ubuntu/bcc/build && cd /home/ubuntu/bcc/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr && \
    make -j"$(nproc)" && \
    make install && \
    # Python binding
    cmake -DPYTHON_CMD=python3 .. && \
    cd /home/ubuntu/bcc/src/python && \
    make && make install

# Clone the analyzer tool
RUN git clone https://github.com/aws/aws-imds-packet-analyzer.git /home/ubuntu/aws-imds-packet-analyzer

# Environment for runtime
ENV LD_PRELOAD=/usr/lib/libbcc.so.0
ENV PYTHONPATH=/usr/lib/python3/dist-packages

WORKDIR /home/ubuntu/aws-imds-packet-analyzer

# Default command: run the analyzer script
CMD ["python3", "/home/ubuntu/aws-imds-packet-analyzer/src/imds_snoop.py"]
