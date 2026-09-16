# https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-minimal-notebook
FROM quay.io/jupyter/minimal-notebook:python-3.13.15

COPY --chown=${NB_UID}:${NB_GID} . ${HOME}
WORKDIR ${HOME}

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       libopengl0 libgl1 libegl1 libxrender1 \
    && rm -rf /var/lib/apt/lists/*
USER ${NB_USER}

RUN pip install -r requirements.txt \
  && pip uninstall gmsh -y \
  && pip install --no-cache-dir --extra-index-url https://gmsh.info/python-packages-dev-nox gmsh==4.13.1.dev1 \
  && fix-permissions "${CONDA_DIR}" \
  && fix-permissions "/home/${NB_USER}"

RUN chmod +x "${HOME}/start"
RUN jupyter server extension enable --sys-prefix --py jupyter_server_proxy

ENV PYVISTA_TRAME_JUPYTER_MODE=proxy
ENTRYPOINT ["./start"]
