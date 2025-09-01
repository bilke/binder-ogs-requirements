ARG BASE_IMAGE_TAG=latest
FROM ghcr.io/pyvista/pyvista:$BASE_IMAGE_TAG

# Install git
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
 && rm -rf /var/lib/apt/lists/*

# Switch back to the original non-root user
USER jovyan

COPY . ${HOME}
WORKDIR ${HOME}
RUN pip install -r requirements.txt && pip install --no-deps ogstools==0.7.0