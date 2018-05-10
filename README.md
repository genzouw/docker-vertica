# docker-vertica

It is a Dockerfile repository for creating an image of "Vertica" which is a column-oriented DB.

## Requirements

Download the MC package from the [myVertica](http://vertica.com/) portal: *vertica-console-current-version.Linux-distro)*

Save the package to a location on the this project root dir.

## Usage

```bash
docker build -t genzouw/vertica .
```

### To run without a persistent datastore

```bash
docker run -p 5433:5433 genzouw/vertica
```

### To run with a persistent datastore

```bash
docker run -P -v $PWD/data:/data genzouw/vertica
```


## Relase Note

| date       | version | note           |
| ---        | ---     | ---            |
| 2019-04-02 | 0.1     | first release. |


## License

This software is released under the MIT License, see LICENSE.


## Author Information

[genzouw](https://genzouw.com)
