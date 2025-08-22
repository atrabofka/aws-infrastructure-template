# Dockerfile for Terragrunt IaC
# Base image includes terraform, terragrunt, terraform-docs
FROM alpine/terragrunt:latest

# Install tflint, checkov, awscli
# Install tflint, create venv for python tools, install checkov and awscli in venv
RUN apk add --no-cache \
    curl \
    python3 \
    py3-pip \
    py3-virtualenv \
    jq \
    git \
    bash \
    && python3 -m venv /opt/pyenv \
    && /opt/pyenv/bin/pip install --upgrade pip \
    && /opt/pyenv/bin/pip install checkov awscli \
    && curl -L https://github.com/terraform-linters/tflint/releases/latest/download/tflint_linux_amd64.zip -o /tmp/tflint.zip \
    && unzip /tmp/tflint.zip -d /usr/local/bin \
    && rm /tmp/tflint.zip

ENV PATH="/opt/pyenv/bin:$PATH"

# No ENTRYPOINT or CMD, use container interactively and mount source directory
