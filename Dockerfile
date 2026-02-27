# https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-minimal-notebook
FROM quay.io/jupyter/minimal-notebook:python-3.12.11

COPY --chown=${NB_UID}:${NB_GID} . ${HOME}
WORKDIR ${HOME}

RUN conda install fenics-dolfinx

RUN pip install -r requirements.txt \
  && pip uninstall vtk gmsh -y \
  && pip install --no-cache-dir --extra-index-url https://wheels.vtk.org vtk-osmesa \
  && pip install --no-cache-dir --extra-index-url https://gmsh.info/python-packages-dev-nox gmsh==4.13.1.dev1 \
  && fix-permissions "${CONDA_DIR}" \
  && fix-permissions "/home/${NB_USER}"
