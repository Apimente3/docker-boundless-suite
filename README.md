# docker-boundless

Docker para [boundless suite](https://boundlessgeo.com/).

## Variables de entorno

* JAVA_OPTS
  * Variable para la configuración de la JVM y plugins de geoserver
  ```
  -Xms2048m -Xmx4096m -XX:SoftRefLRUPolicyMSPerMB=36000 -XX:-UsePerfData -Dorg.geotools.referencing.forceXY=true -Dorg.geotoools.render.lite.scale.unitCompensation=true -Xbootclasspath/a:/usr/local/tomcat/lib/marlin-0.7.3-Unsafe.jar -Dsun.java2d.renderer=org.marlin.pisces.PiscesRenderingEngine -Dsun.java2d.renderer.useThreadLocal=false -Djava.library.path=/usr/lib:/usr/lib/jni:/opt/libjpeg-turbo/lib64:/usr/lib64 -Xbootclasspath/a:/opt/tomcat/lib/marlin-0.7.3-Unsafe.jar -Dsun.java2d.renderer=org.marlin.pisces.PiscesRenderingEngine -Dsun.java2d.renderer.useThreadLocal=false -server
  ```
* GEOSERVER_DATA_DIR 
  * Monta un volumen con una configuración previa de geoserver, por defecto se usa `/var/opt/boundless/server/geoserver/default_data` 

## Endpoints
| Endpoint    | Description            |
|-------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| /composer    | Herramienta para la creación y estilización de mapas.            |
| /geoserver   | Herramienta para la gestión y publicación de datos geograficos. |
| /quickview   | Herramienta para la consulta de los datos.     |

## Geoserver
Las contraseñas por default son ```admin:geoserver```, recuerda cambiarlas para una mayor seguridad de tu servicio.
Enlaces útiles:
- [WMS reference](http://docs.geoserver.org/latest/en/user/services/wms/reference.html)
- [WFS reference](http://docs.geoserver.org/latest/en/user/services/wfs/reference.html)
- [Formatos de respuesta](http://docs.geoserver.org/latest/en/user/services/wms/outputformats.html#wms-output-formats)

### Web Map Service (WMS)

```wms_service = http://10.20.55.7:8000/geoserver/cedn/wms```

#### GetCapabilities
Esta operación regresa datos acerca de las operaciones permitidas, servicios instalados y capacidades de datos (catálogos) que son ofrecidas a través del servicio.
- /wms?service=WMS&version=1.1.0&request=GetCapabilities

La respuesta es un archivo XML con las siguientes secciones:
1. **Service.**	Contains service metadata such as the service name, keywords, and contact information for the organization operating the server.
2. **Request.** Describes the operations the WMS service provides and the parameters and output formats for each operation. If desired GeoServer can be configured to disable support for certain WMS operations.
3. **Layer.** Lists the available coordinate systems and layers. In GeoServer layers are named in the form “namespace:layer”. Each layer provides service metadata such as title, abstract and keywords.

```http://10.20.55.7:8000/geoserver/cedn/wms?service=WMS&version=1.1.0&request=GetCapabilities```

#### GetMap
Hace una petición al servidor para crear un mapa con las opciones especificadas, la respuesta puede ser una imagen o un mapa navegable dependiendo de los parametros.

| Parametro   | Necesario | Descripción                                                                                                           |
|-------------|-----------|-----------------------------------------------------------------------------------------------------------------------|
| service     | Si        | Nombre del servicio                                                                                                   |
| version     | Si        | Versión del servicio                                                                                                  |
| request     | Si        | Operación (GetMap)                                                                                                    |
| layers      | Si        | Capas a agregar al mapa                                                                                               |
| styles      | Si        | Estilos con los que se renderizaran las capas                                                                         |
| srs \| crs   | Si        | Referencia espacial de los datos                                                                                      |
| bbox        | Si        | Extensión del mapa (minx,miny,maxx,maxy)                                                                              |
| width       | Si        | Largo del mapa (en pixeles)                                                                                           |
| height      | Si        | Alto del mapa (en pixeles)                                                                                            |
| format      | Si        | Formato de la respuesta (http://docs.geoserver.org/latest/en/user/services/wms/outputformats.html#wms-output-formats) |
| transparent | No        | Transparencia en el fondo del mapa (true - false)                                                                     |
```
http://10.20.55.7:8000/geoserver/cedn/wms?
service=WMS&
version=1.1.0&
request=GetMap&
layers=cedn:a03aa4bf0_bb83_4e80_81c6_d555a8f88af4&
styles=&
bbox=-117.119365023744,14.6798467556345,-86.8264617652098,32.6673450147208&
width=768&
height=456&
srs=EPSG:4326&
format=image/svg
```

#### GetFeatureInfo
Consulta los datos que se encuentran en el sistema cerca de una ubicación especificada.

| Parametro     | Necesario | Descripción                                                            |
|---------------|-----------|------------------------------------------------------------------------|
| service       | Si        | Nombre del servicio                                                    |
| version       | Si        | Versión del servicio                                                   |
| request       | Si        | Operación (GetFeatureInfo)                                             |
| layers        | Si        | Capas a agregar al mapa                                                |
| styles        | Si        | Estilos con los que se renderizaran las capas                          |
| srs \| crs    | Si        | Referencia espacial de los datos                                       |
| bbox          | Si        | Extensión del mapa (minx,miny,maxx,maxy)                               |
| width         | Si        | Largo del mapa (en pixeles)                                            |
| height        | Si        | Alto del mapa (en pixeles)                                             |
| query_layers  | Si        | Lista separada por comas con las capas que se incluiran en la busqueda |
| x             | Si        | Coordenada en el mapa (en pixeles)                       |
| y             | Si        | Coordenada en el mapa (en pixeles)                        |
| info_format   | No        | Formato de respuesta                                                   |
| feature_count | No        | Máximo número de objetos a regresar                                    |

```
http://10.20.55.7:8000/geoserver/cedn/wms?
request=GetFeatureInfo&
layers=cedn:a03aa4bf0_bb83_4e80_81c6_d555a8f88af4&
query_layers=cedn:a03aa4bf0_bb83_4e80_81c6_d555a8f88af4&
bbox=-117.119365023744,14.6798467556345,-86.8264617652098,32.6673450147208&
srs=EPSG:4326&
width=400&
height=400&
x=200&
y=200&
buffer=300
```


### Web Feature Service (WFS)
``` http://10.20.55.7:8000/geoserver/cedn/wfs ```

### Operaciones
| Operación           | Descripción                                                           |
|---------------------|-----------------------------------------------------------------------|
| GetCapabilities     | Genera un documento describiendo las características del servicio WFS |
| DescribeFeatureType | Regresa una lista con las geometrias soportadas por el servicio       |
| GetFeature          | Regresa una selección de objetos                                      |

#### GetCapabilities
``` http://10.20.55.7:8000/geoserver/cedn/wfs?request=GetCapabilities ```

#### DescribeFeatureType
``` http://10.20.55.7:8000/geoserver/cedn/wfs?request=describeFeatureType&outputFormat=application/json ```

#### GetFeature
Para obtener todos los objetos de una capa usa el comando:
- ``` /wfs?service=wfs&request=GetFeature&outputFormat=application/json&typeNames=cedn:a03aa4bf0_bb83_4e80_81c6_d555a8f88af4 ```

Puedes usar las siguientes opciones para refinar tu busqueda:

| Operación | Descripción | Ejemplo
|-----------|-------------|--------
|featureID|Identificador del objeto | featureID=a4223423
|count \| maxFeatures|Especifica el máximo número de objetos a regresar | count=10
|sortBy|Especifica un atributo con el que se ordenara la respuesta, especifica con +A o +D si es ascendente o descendente |sortBy=attribute+D
propertyName|Especifica una propiedad (o una lista) con la que se filtraran los datos|propertyName=attribute,attribute_2
bbox|Especifica la extensión geografica de la consulta|bbox=-117.119365023744,14.6798467556345,-86.8264617652098,32.6673450147208

## Composer
Herramienta de ayuda para la creación de mapas consumiendo la información del sistema o datos externos.
Los mapas generados con esta herramienta son consultables desde los servicios WMS y WFS.
![Composer](https://github.com/mxabierto/docker-boundless-suite/blob/master/img/ss_composer.png?raw=true "Composer")

## Licencia
docker-boundless es software libre, y puede ser redistribuido bajo los términos especificados en nuestra [licencia](https://datos.gob.mx/libreusomx).

## Sobre México Abierto
En México Abierto creamos mecanismos de innovación y colaboración entre ciudadanos y gobierno con herramientas digitales, para	impulsar el desarrollo del país.
