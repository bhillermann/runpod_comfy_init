#!/bin/bash

# 1. Setup Blackwell-optimized Virtual Environment in persistent storage
python3 -m venv /workspace/comfy_venv
source /workspace/comfy_venv/bin/activate

# 2. Clone ComfyUI and Core Extensions
cd /workspace
if [ ! -d "ComfyUI" ]; then
    git clone https://github.com
fi

cd /workspace/ComfyUI/custom_nodes
[ ! -d "ComfyUI-Manager" ] && git clone https://github.com
[ ! -d "ComfyUI-Civitai-Helper" ] && git clone https://github.com

# 3. Install Dependencies while protecting System PyTorch (CUDA 12.8)
cd /workspace/ComfyUI
grep -vE "torch|torchvision|torchaudio" requirements.txt > temp_req.txt
pip install -r temp_req.txt
pip install -r custom_nodes/ComfyUI-Manager/requirements.txt
pip install jupyterlab

# 4. Launch Services
# Start Jupyter in background for file management
jupyter lab --allow-root --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' &

# Start ComfyUI (Primary process)
python main.py --listen 0.0.0.0 --port 8188 --enable-manager
