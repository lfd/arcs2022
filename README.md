# ARCS - 2022

## Setup

### Clone repository

```
git clone https://github.com/lfd/arcs2022.git
```


### Docker

```
docker build -t local/arcs2022 arcs2022
docker run -ti -p 127.0.0.1:8888:8888 --name arcs2022 local/arcs2022
```

### Local

```
pip install -r requirements.txt
./run.sh jupyter
```

### Start 
Open the generated Jupyter Notebook link from the terminal .
