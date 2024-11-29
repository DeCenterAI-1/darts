# Darts


# How to Install via CLI [Recommended for Linux/UNIX/OSX]

1. git clone https://github.com/DeCenterAI-1/darts
2. cd darts
3. chmod +x ./install.sh
4. sudo ./install.sh all


# How to Install [Manually]

1. Go to releases: [Darts Releases](https://github.com/DeCenterAI-1/darts/releases/latest)
     <img width="356" alt="image" src="https://github.com/user-attachments/assets/2a731083-ce9d-40c4-93fb-0377d101e591">

2. Download `darts` cli for your os
3. Run darts

   ```

   chmod +x darts
   ./darts run cowsay:v0.1.3 -i Message="Your Name"
  
   ```

# Quickstart: Darts

1. `export DARTS_PRIVATE_KEY="0x...`
2. `darts run cowsay:v0.1.3 -i Message="DecenterAI.com is the best"`


## Stable Diffusion


### CPU
```
darts run github.com/darts2024/dart-isdxl:v0.3.0 -i Prompt="cat sit on a trampoline" -i Device="cpu" -i cpu=10
```

### GPU [Intel]

```
darts run github.com/darts2024/dart-isdxl:v0.3.0 -i Prompt="cat sit on a trampoline" -i Device="xpu" 
```
