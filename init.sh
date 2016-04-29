#!/bin/sh
pip install flask-mysql flask uwsgi

sudo apt-get install -y nginx supervisor

sudo ln -fs /opt/flask-wishlist-app/flask-wishlist-app-uwsgi.ini /etc/flask-wishlist-app-uwsgi.ini
sudo ln -fs /opt/flask-wishlist-app/flask-wishlist-app-nginx.conf /etc/nginx/sites-enabled/flask-wishlist-app-nginx.conf
sudo ln -fs /opt/flask-wishlist-app/flask-wishlist-app-supervisor.conf /etc/supervisor/conf.d/flask-wishlist-app-supervisor.conf

sudo unlink /etc/nginx/sites-enabled/default
sudo /etc/init.d/nginx restart
sudo /etc/init.d/supervisor restart
sudo supervisorctl start flask-wishlist-app
