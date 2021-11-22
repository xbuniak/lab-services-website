# Default will get ppc64le
FROM alpine
# ARM 64/v8
#FROM alpine@sha256:bd9137c3bb45dbc40cde0f0e19a8b9064c2bc485466221f5e95eb72b0d0cf82e

# ---------------------------- #
#   Http server installation   #
# ---------------------------- #

RUN apk add --no-cache apache2

# ---------------------- #
#   Adding Web Content   #
# ---------------------- #

COPY website/ /var/www/localhost/htdocs/

# Change right access for none-root usage (make it works on openshift)
RUN chown -R apache:0 /var/www/localhost/htdocs && chmod -R g=u /var/www/localhost/htdocs \
	&& chown apache:0 /var/log/apache2 && chmod -R g=u /var/log/apache2 \
	&& ln -sf /dev/stdout /var/log/apache2/access.log \
	&& ln -sf /dev/stderr /var/log/apache2/error.log \
	&& mkdir -p /run/apache2 && chown -R apache:0 /run/apache2 && chmod -R g=u /run/apache2
COPY httpd.conf /etc/apache2/httpd.conf

# ---------------- #
#   Expose Ports   #
# ---------------- #
EXPOSE  8080

# -------- #
#   Run!   #
# -------- #
USER apache
CMD     ["/usr/sbin/httpd","-D","FOREGROUND"]
