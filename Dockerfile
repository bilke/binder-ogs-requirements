# https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-minimal-notebook
FROM quay.io/jupyter/minimal-notebook:python-3.12.11

COPY --chown=${NB_UID}:${NB_GID} . ${HOME}
WORKDIR ${HOME}

RUN pip install -r requirements.txt \
  && pip uninstall gmsh -y \
  && pip install --no-cache-dir --extra-index-url https://gmsh.info/python-packages-dev-nox gmsh==4.13.1.dev1 \
  && conda install -y -c conda-forge "ogs=6.5.8=*openmpi*" \
  && fix-permissions "${CONDA_DIR}" \
  && fix-permissions "/home/${NB_USER}"

RUN chmod +x "${HOME}/start"

ENTRYPOINT ["./start"]