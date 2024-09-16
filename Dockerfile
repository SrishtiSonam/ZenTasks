# First - Define the step that docker needs in order to build our image.
#       - Define the name of the image that we are going to use. { Base image - pull from Docker Hub }
#           that we are going to build on top of to add dependencies that we need for our project.

FROM python:3.9-alpine3.13
# python - Name of Docker image on Docker Hub, 3.9-alpine3.13 is the name of the using tag.
# alpine - Light weight version of linux - Ideal for running docker container - very stripped back - no unnecessary dependencies. 


# Second - Define maintainer - Name of the person
LABEL maintainer = "SrishtiSonam"


# Third - Defining Environment - For running python in docker container 
ENV PYTHONUNBUFFERED 1                  
    # Ask python to not buffer the output - Output will be directly printed to the console - No delay of messages from python application to screen - logs come immediately on the screen. 
    
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000
# COPY form - to - { inside the container } 
# WORKDIR - Working directory - Default directory - From where commands will run on our Docker image.
# Expose port 8000 from our container to machine, on running the container.


ARG DEV=false
# Build argument 'DEV' and sets default value to false. 

RUN python -m venv /py && \                 
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    # A shell script        -       Condotionally       - fi - format for ending the if statement
    if [ $DEV = 'true']; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user 

# Run command to install some depencencies
# Runs the command on alpine image that we are using when we are building our image.
# Here we broke the commands down onto one run block
#   {   Every single command that we RUN - create new image layer, to keep it light wait we broke    }

# 1. Create a new virtual environment, use to store our dependencies.
# { Virtual env not required when working on Docker MOSTLY, but for some edge cases where python dependencies on actual base image might conflict with python dependencies of your project  }

# 2. Upgrading pip for virtual env. '/py/bin/pip' - Full path of our virtual env.

# 3. Installing our requiremnts in our virtual environment.

# 4. Then remove the tmp directory '/tmp' as we don't want any extra dependences on our actual image - as lightweight as possible - remove extra in build process.

# 5. Add user block - Add user Command ->   Add new user inside our image   { To not to use root user }
    # If not specified this bit then only user available inside alpine image would be the root user.
    # Root user - Full access and permissions to do everything on the server.
    # { Don't run your application using the root user - attacker have full access of docker conatiner. }
    # No password to log on, just by default.
    # No home directory for the user - Not nesseccary and light weight.
    # django-user -> Specify the name of the user - an app so call whatever.


ENV PATH="/py/bin:$PATH"
# Updates the env variable inside the image and updating the path environment variable. 
#  PATH - Env variable, automatically created on OS.
# Define all of the directories where executables can run.


USER django-user
# User line
# Specify hte user that we are switching to.
# Before this everything was running by root user.
# Containers that are made out of this image will run using the last user that image is switched to.
# Any time that we run something from this image it's going to run as the django-user.