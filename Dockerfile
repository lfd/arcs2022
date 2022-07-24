FROM fedora:34

LABEL author="Hila Safi <hila.safi@siemens.com>"

RUN dnf install -y python3 python3-devel ImageMagick unzip gcc git

RUN adduser arcs && mkdir -p /usr/local/arcs && chown -c arcs /usr/local/arcs

USER arcs

RUN python3 -m venv /usr/local/arcs/venv

RUN /usr/local/arcs/venv/bin/pip install --upgrade pip && \
    /usr/local/arcs/venv/bin/pip install jupyter

RUN /usr/local/arcs/venv/bin/pip install arcs

RUN /usr/local/arcs/venv/bin/python -m qat.magics.install

WORKDIR /home/arcs

RUN git clone https://github.com/lfd/arcs2022.git

RUN mkdir -p /home/arcs/arcs_2022

EXPOSE 8888

ENV PATH "/usr/local/arcs/venv/bin/:${PATH}"

COPY Generate_and_extend_IBM-Q_topology.ipynb plot_custom_hardware_maxcut.ipynb run_custom_hardware_maxcut.ipynb run_qaoa_profiler.py /home/arcs/arcs_2022

CMD ["jupyter", "notebook",  "--no-browser", "--ip=0.0.0.0"]
