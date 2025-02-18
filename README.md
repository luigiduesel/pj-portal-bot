# PJ-Portal Bot for Checking Available Slots
## 🔐 An open-source, data-privacy-oriented alternative to quickpj.de 🔐
Many medical students face challenges securing a spot at their preferred hospital for their PJ. While [quickpj.de](quickpj.de) provides a convenient way to receive notifications when desired slots become available on pj-portal.de, its approach raises privacy concerns. The platform requires full login credentials, which, if compromised, could allow third parties to deregister students from their entire practical training. Additionally, quickpj.de is a paid service, adding a financial barrier for students. This open-source approach lets you run your own bot as a simple docker container on your own hardware to ensure full control over your sensitive data like your login credentials to the pj-portal.de. The necessary technical skills to run this bot are considerable low and all the required setup steps are explained in detail in the following. The hardware requirements are very minimal, allowing it to run on Raspberry Pis, vServer of Cloud Hosers or your own PC.

## 📝 Prerequisites 📝
Your university must be among the participating universities of the pj-portal.de and you must already have obtained login credentials for the platform. A list of the participating universities can be found on pj-portal.de. Those include currently:
- Universität Münster
- RWTH Aachen 
- Universität Augsburg
- Charité Berlin
- MSB Berlin
- Ruhr Universität Bochum
- Universität Bonn
- Medizinische Hochschule Brandenburg
- Technische Universität Dresden
- Heinrich-Heine-Universität Düsseldorf
- FAU Erlangen-Nürnberg
- Goethe Universität Frankfurt am Main
- Justus-Liebig-Universität Giessen
- Georg-August-Universität Göttingen
- Universität Greifswald
- Martin-Luther-Universität Halle-Wittenberg
- MSH Medical School Hamburg
- Universität Hamburg
- Medizinische Hochschule Hannover
- Universität Heidelberg
- Friedrich-Schiller-Universität Jena
- Christian-Albrechts-Universität zu Kiel
- Universität Leipzig
- Universität zu Lübeck
- Otto-von-Guericke-Universität Magdeburg
- Johannes Gutenberg-Universität Mainz 
- Philipps-Universität Marburg
- LMU München
- TU München
- Carl von Ossietzky Universität Oldenburg
- Health and Medical University Potsdam
- Universität Rostock
- Universität des Saarlandes
- Eberhard Karls Universität Tübingen
- Universität Ulm
- Universität Witten/ Herdecke
- Julius-Maximilians-Universität Würzburg



## 🚀 How to use 🚀
### 1. Set up Pushover 🔑
1. Go to https://pushover.net/signup and sign up for a Pushover account and 30-days-trial
2. Save your Pushover User Key (could look like xg7m2vtqnflo5p3zbkydw64cjj8r9s)
3. Register your device e.g. your phone by downloading the app and login 
4. Create an application (https://pushover.net/apps/build)
5. Save your Pushover Application API Token/Key (could look like a4ot22m6d3569wwk76wpgsc3jdyfv4)


### 2. Retrieve ajax_uid 🔬
1. Go to pj-portal.de
2. Login with your credentials
3. Go to tab "PJ Angebot"
4. Open the Developer Tools of your browser (e.g. for Chrome use F12)
5. Switch to tab "Network" in Developer Tools
6. Clear network log (Crtl + L)
7. Hit the big refresh button on the website (Merkliste aktualisieren) and don't refresh the whole page from your browser
8. Click on the ajax.php request on the left in the Network tab of the Developer Tools
9. Click on Tab "Payload" of the ajax.php request (next to Headers)
10. Copy the AJAX_ID value (should be somewhat like a 7-digit integer)

### 3a. Clone docker image from hub.docker.com 📄
The docker image of this repository is already publicly available on Docker Hub and can be pulled with:

`docker pull madrhr/pjportalbot`

### 3b. Build your custom image ⚒️

Clone the repository in a directory on your file system. 

To build the contianer, you can use the following build command. 

`docker buildx build --platform linux/amd64,linux/arm64 -t pjportalbot .`

### 4. Prepare Environment Variables 🧪
| ENV | Example | Description |
|----------|----------|----------|
| pushover_user | xg7m2vtqnflo5p3zbkydw64cjj8r9s | user key from pushover |
| pushover_token | a4ot22m6d3569wwk76wpgsc3jdyfv4 | token from pushover after creating a application |
| pjportal_user | max.mustermann@uni-muster.de | your e-mail address for pj-portal.de |
| pjportal_pwd | super-secure-password1 | your password for pj-portal.de |
| ajax_uid | 5102130 | ajax_uid as described above |
| pj_tag | Allgemeinmedizin | E.g. "Chirurgie", "Innere Medizin", "Allgemeinmedizin", "Anästhesiologie", ... (Correct spelling is absolutely necessary. Therefore go to the Tab "PJ Angebot", then "Krankenhäuser" and then open your desired university and copy the correct name of specialty field) |
| hospital | Ulm Universitätsklinikum | E.g. "Ulm Universitätsklinikum", "Berlin Charité", "Hamburg Univ.", ... (Correct spelling is absolutely necessary. Therefore go to the Tab "PJ Angebot" and then "Krankenhäuser" next to Merkliste and copy and paste the correct name) |
| term | second_term | specify: "first_term" (1. Tertial), "second_term" (2. Tertial) or "third_term" (3. Tertial) |
| check_frequency_lower_limit | 60 | Lower boundary for random check intervall |
| check_frequency_upper_limit | 360 | Upper boundary for random check intervall |
| cookie_filepath | /usr/src/app/cookie.txt | Filepath for saving the cookie in the container |
| cookie_default_value | 901p3g53lo041j4pcl5po5xcws | (optional) possible to preset a cookie |


### 5a. Spin a container with Docker Hub image ▶️
To spin up a container with the environment variables and access to an interactive console (TTY), you can use the following docker run command:

`docker run -it --platform linux/amd64,linux/arm64 \
  --env pushover_user="xg7m2vtqnflo5p3zbkydw64cjj8r9s" \
  --env pushover_token="a4ot22m6d3569wwk76wpgsc3jdyfv4" \
  --env pjportal_user="max.mustermann@uni-muster.de" \
  --env pjportal_pwd="super-secure-password1" \
  --env ajax_uid="5102130 \
  --env pj_tag="Allgemeinmedizin" \
  --env hospital="Berlin Charité" \
  --env term="second_term" \
  --env check_frequency_lower_limit="60" \
  --env check_frequency_upper_limit="360" \
  --env cookie_filepath="/usr/src/app/cookie.txt" \
  --env cookie_default_value="901p3g53lo041j4pcl5po5xcws" \
  --name pjportalbot\
  madrhr/pjportalbot`

### 5b. Spin up your custom image ▶️
To spin up a container with the environment variables and access to an interactive console (TTY), you can use the following docker run command:

`docker run -it --platform linux/amd64,linux/arm64 \
  --env pushover_user="xg7m2vtqnflo5p3zbkydw64cjj8r9s" \
  --env pushover_token="a4ot22m6d3569wwk76wpgsc3jdyfv4" \
  --env pjportal_user="max.mustermann@uni-muster.de" \
  --env pjportal_pwd="super-secure-password1" \
  --env ajax_uid="5102130 \
  --env pj_tag="Allgemeinmedizin" \
  --env hospital="Berlin Charité" \
  --env term="second_term" \
  --env check_frequency_lower_limit="60" \
  --env check_frequency_upper_limit="360" \
  --env cookie_filepath="/usr/src/app/cookie.txt" \
  --env cookie_default_value="901p3g53lo041j4pcl5po5xcws" \
  --name pjportalbot\
  pjportalbot`

This will start the container and give you access to an interactive shell.

### 6. Access interactive shell e.g. for checking logs. 📜
If you need to access the shell in a running container later, you can do so with:

`docker exec -it pjportalbot /bin/bash`

### 7. Test the notification with a different env configuration (optional) 📲
It is strongly suggested testing the notification of the bot by using a configuration that returns guaranteed open slots and therefore safely triggers a push notification to your device.

## 🤝 Contribution 🤝
Contribution to this repository is warmly welcomed. Please feel free to open a pull-request.


## 💬 Support 💬
If you have a question, feel free to open a new issue for this repository.
