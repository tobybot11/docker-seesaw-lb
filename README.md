

# build

docker build -t tobybot11/seesaw-lb .


# run

docker run --privileged='true' -it --rm --name ss tobybot11/seesaw-lb 

privileged='true' .. only while i try to figure out what is required from setcap settings
without this, i get errors

# start seesaw

/usr/local/seesaw/seesaw_watchdog -v 10 -logtostderr

this currently gives a 255 error from seesaw_engine , while the configuration isn't correct


