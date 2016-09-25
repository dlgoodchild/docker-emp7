# docker-emp7
Docker setup for Nginx, MySQL and PHP7.  
Compile any version of PHP greater than 5.4.

### What's Installed
1. PHP7.1RC2
 - Xdebug 2.4.1
 - IMagick extension
 - ImageMagick library
 - wkhtmltopdf library
 - Sass compiler
 - Composer
2. Nginx (latest from apt-get on Ubuntu 14.04 / Trusty)
3. MySQL 5.5 (Ubuntu 14.04 / Trusty)

### Usage
1. Clone this repository into a folder named _docker_.  
2. Update the _.env_ file with a read-only github authentication token (this is optional).  
3. Also provide a unique (to you) project prefix; this is so you can build multiple instances if you need.  
4. If you're installing on MacOSX manually edit the _php7/Dockerfile_. Uncomment the line `RUN usermod -u 1000 www-data`
5. Run `cd docker`; if you named the folder _docker_ as per step 1.
6. Run `docker-compose -p $project_prefix build` using the same _project_prefix_ defined in _.env_
7. Run `docker-compose -p $project_prefix up -d` 

### Project Integration
Optionally delete the .git after clone and commit direct to your project's root directory under the _docker_ folder.


