FROM fedora:34

LABEL author="Hila Safi <hila.safi@siemens.com>"

RUN dnf install -y python3 python3-devel ImageMagick unzip gcc git

RUN adduser arcs2022 && mkdir -p /usr/local/arcs2022 && chown -c arcs2022 /usr/local/arcs2022

USER arcs2022

RUN python3 -m venv /usr/local/arcs2022/venv

RUN /usr/local/arcs2022/venv/bin/pip install --upgrade pip && \
    /usr/local/arcs2022/venv/bin/pip install jupyter

RUN /usr/local/arcs2022/venv/bin/pip install qat-lang
RUN /usr/local/arcs2022/venv/bin/pip install scipy
RUN /usr/local/arcs2022/venv/bin/pip install qiskit
RUN /usr/local/arcs2022/venv/bin/pip install notebook
RUN /usr/local/arcs2022/venv/bin/pip install qiskit-optimization
RUN /usr/local/arcs2022/venv/bin/pip install pytket
RUN /usr/local/arcs2022/venv/bin/pip install pytket-qiskit
RUN /usr/local/arcs2022/venv/bin/pip install networkx
RUN /usr/local/arcs2022/venv/bin/pip install matplotlib
RUN /usr/local/arcs2022/venv/bin/pip install pydot
RUN /usr/local/arcs2022/venv/bin/pip install numpy

RUN /usr/local/arcs2022/venv/bin/python -m qat.magics.install

WORKDIR /home/arcs2022

RUN git clone https://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@github.com/lfd/arcs2022.git

RUN mkdir -p /home/arcs2022/arcs2022

#RUN /usr/local/arcs2022/venv/bin/pip install -r requirements.txt

EXPOSE 8888

ENV PATH "/usr/local/arcs2022/venv/bin/:${PATH}"

#RUN pip install -r /home/arcs2022/requirements.txt

#COPY Generate_and_extend_IBM-Q_topology.ipynb plot_custom_hardware_maxcut.ipynb run_custom_hardware_maxcut.ipynb run_qaoa_profiler.py /home/arcs2022/arcs2022_2022

CMD ["jupyter", "notebook",  "--no-browser", "--ip=0.0.0.0"]
