import os
import multiprocessing
from dotenv import load_dotenv

load_dotenv()

# Server Socket
bind = f"0.0.0.0:{os.getenv('PORT', '8088')}"

# Worker Processes
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "uvicorn.workers.UvicornWorker"

# Logging
accesslog = "-"
errorlog = "-"
loglevel = "info"

# Process Naming
proc_name = "pybridge_api"
