# Use an appropriate base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file into the container
COPY app/requirements.txt /app/requirements.txt

# Copy the rest of the application code into the container
COPY app/ /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 5000
EXPOSE 5000

# Define the command to run the application
CMD ["python", "app.py"]
