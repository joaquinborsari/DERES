# Utiliza una imagen específica de Flutter de Cirrus CI como base
FROM cirrusci/flutter:stable AS builder

# Crear un nuevo usuario para evitar ejecutar como root
RUN useradd -ms /bin/bash flutteruser

# Cambiar los permisos del directorio de Flutter
USER root
RUN chown -R flutteruser:flutteruser /sdks/flutter

# Cambiar al usuario flutteruser
USER flutteruser

# Establece el directorio de trabajo para el contenedor
WORKDIR /app

# Copia los archivos del proyecto Flutter al contenedor
COPY --chown=flutteruser:flutteruser . /app

# Muestra la versión de Flutter y Dart para depuración
RUN flutter --version
RUN dart --version

# Obtén las dependencias del proyecto Flutter
RUN flutter pub get

# Compila la aplicación para la web
RUN flutter build web

# Utiliza una imagen ligera de Nginx para servir la aplicación construida
FROM nginx:alpine

# Copia la aplicación web compilada al directorio de Nginx
COPY --from=builder /app/build/web /usr/share/nginx/html

# Expone el puerto que utiliza Nginx (80 por defecto)
EXPOSE 80

# Comando para iniciar Nginx y servir la aplicación
CMD ["nginx", "-g", "daemon off;"]
