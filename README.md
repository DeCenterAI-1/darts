🛠 How to Install via CLI (Recommended for Linux/UNIX/macOS)

`curl -sSL https://bit.ly/install-darts | sudo bash -s -- all`

📦 How to Install Manually

1. **Download the Latest Release:**  
   - Visit [Darts Releases](https://github.com/DeCenterAI-1/darts/releases/latest)
   - Download the appropriate `darts` CLI package for your operating system.  
2. **Locate the Downloaded File:**  
  - On Linux/macOS: Open the terminal and navigate to the folder where the package was downloaded.  
  - On Windows: Use File Explorer to locate the downloaded file and extract the executable
3. **Rename the File:**  
  - Rename the downloaded package to `darts`.  

4. **Move the File to a System Path:**  
  - **Linux/macOS:**  
    Move the `darts` file to `/usr/local/bin` to make it accessible globally:  
    ```bash  
    sudo mv darts /usr/local/bin/  
    ```  

  - **Windows:**  
    Move the `darts.exe` file to a location in your system’s PATH (e.g., `C:\Program Files\Darts`).  
    Alternatively, you can add the folder containing `darts.exe` to your PATH:  
    1. Right-click on **This PC** or **My Computer** and select **Properties**.  
    2. Click **Advanced System Settings** → **Environment Variables**.  
    3. Under **System Variables**, find **Path** and click **Edit**.  
    4. Add the folder where `darts.exe` is located and click **OK**.  

5. **Verify the Installation:**  
  Open a terminal (or Command Prompt on Windows) and run:  
  ```shell  
  darts --version 
  ```
  > If the installation was successful, the version number should be displayed.

🚀 Quickstart

🐄 cowsay Module

`darts run cowsay:v0.1.3 -i Message="DecenterAI.com is the best"`

```stdout
    ____________________________
< DecenterAI.com is the best >
----------------------------
        \   ^__^
        \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||

```

🖼 isdxl Module: Stable Diffusion


```shell
darts run github.com/darts2024/dart-isdxl:v0.3.0 -i Prompt="cat sit on a trampoline" -i Device="cpu" -i cpu=10
```

<p align="center">
  <img src="https://github.com/user-attachments/assets/9d0ddc75-2965-45de-bbeb-624304a9d3aa" alt="Cat Sitting on Trampoline" width="300">
<br>
*Figure: A cat enjoying its time on a trampoline.*
</p>

---

```shell
darts run github.com/darts2024/dart-isdxl:v0.3.0 -i Prompt="Beautiful girll" -i Device="xpu"
```

<p align="center">
  <img src="https://github.com/user-attachments/assets/f12ba093-560f-4087-b12e-b5a63e1bec98" alt="Beautiful Girl" width="250">
<br>
   *Figure Beautiful Girl*
</p>

---

```shell
darts run isdxl:v0.3.0 -i Device="xpu" -i Seed=42 -i Prompt="A hyperrealistic portrait of a futuristic cityscape at sunset, with towering skyscrapers and neon-lit streets. A flying car hovers near a glass bridge, reflecting soft orange and pink hues. The scene is detailed with glowing billboards, distant mountains, and a bustling crowd below. The lighting emphasizes the vibrant colors of the sunset blending with the neon glow. Shot in cinematic widescreen with depth-of-field effects, creating an immersive sci-fi atmosphere" 
```

<p align="center">
  <table>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/e6c82290-55da-453e-9dd5-e6c8cc6b1cd3" alt="Futuristic skyscraper" width="300"></td>
      <td><img src="https://github.com/user-attachments/assets/1486b95b-ec8b-4b88-9445-2b3f9b99dbbe" alt="Futuristic skyscraper1" width="300"></td>
      <td><img src="https://github.com/user-attachments/assets/5a07e80a-8c81-433c-ab85-a367a677c14e" alt="Futuristic skyscraper2" width="300"></td>
    </tr>
    <tr>
      <td align="center">Seed 42</td>
      <td align="center">Seed 30</td>
      <td align="center">Seed 100</td>
    </tr>
  </table>
</p>

---

```shell
darts run isdxl:v0.3.0 -i Prompt="mind dreaming of a futuristic aircraft" -i Seed="1" -i Device="xpu"
```


<p align="center">
  <table>
    <tr>
      <td><img src="https://github.com/user-attachments/assets/5026abe3-2718-450f-89ed-5e511ce47905 alt="Futuristic aircraft" width="300"></td>
      <td><img src="(https://github.com/user-attachments/assets/ac24833e-838a-4d07-8d58-e3408508315b" alt="Futuristic aircraft" width="300"></td>
      <td><img src="https://github.com/user-attachments/assets/c7a4c5e9-6713-4b7e-a2ac-7a78414f5491" alt="Futuristic aircraft" width="300"></td>
    </tr>
    <tr>
      <td align="center">Seed 1</td>
      <td align="center">Seed 40</td>
      <td align="center">Seed 12</td>
    </tr>
  </table>
</p>


## Changelog
* d4cf78c doc: tidy
* 5708c4a tidy: figure

🙏 Thanks

Those were the changes on v0.205.3!


🔄 Update Notes

- If you encounter any issues or have questions, feel free to open an issue in our [GitHub repository](https://github.com/DeCenterAI-1/darts/issues).
- Keep an eye out for upcoming features and improvements!

👥 Community & Support

- Join the community discussions on [Telegram](https://t.me/decenterai).
- Check out the [official documentation](https://decenter-ai.gitbook.io/).
- Follow us on [Twitter](https://twitter.com/DeCenterAI).

❤️ Show Your Support

- ⭐️ Give us a star on [GitHub](https://github.com/DeCenterAI-1/darts).
- 🧑‍💻 Request a feature or report a bug at [GitHub Issues](https://github.com/DeCenterAI-1/darts/issues/new).

Thanks for being a part of the Darts community! 🚀

