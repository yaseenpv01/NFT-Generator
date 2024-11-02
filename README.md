# NFT Generator and Listing App

This project is an NFT generator and listing application that leverages the Stability Image Generation API to create unique NFT images. Users can generate NFTs and list them within the app, with images powered by Stability's API for high-quality, AI-generated artwork.

## Features
 - NFT Image Generation: Uses the Stability Image Generation API to generate unique images for NFTs.
 - NFT Listing: Allows users to list generated NFTs for display.
 - Environment Variable Management: API keys and sensitive information are stored in a .env file for security.

## Technologies Used
 - Flutter for front-end and cross-platform development.
 - Image Processing: Send an image along with a prompt and receive a processed response.
 - Dart for backend and Flutter logic.


## Prerequisites

Before running the app, make sure you have the following:

- Flutter: Ensure you have Flutter installed. Get Flutter.
- An Android or iOS device/emulator
- Stability API Key: You need a Stability API key to use the image generation functionality. Sign up at Stability.ai to obtain an API key.

## Setup Instructions

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yaseenpv01/NFT-Generator.git
   cd your-repo-name

2. **Environment Variables*

   - Create a .env file in the root directory.
   - Add your Stability API key and other necessary environment variables in the .env file. Here’s an example:
     
  
   ```bash
   STABILITY_API_KEY=your_stability_api_key_here


3. **Install Dependencies**
   - Run the following command to install all required dependencies:

   ```bash
   flutter pub get

4. **Run the App**
   - Start the app on an emulator or connected device:

   ```bash
   flutter run

## Usage
 - Open the app and navigate to the NFT generation section.
 - Enter details and trigger the image generation using the Stability API.
 - Review generated images and list them as NFTs in the listing section.

## Contributing
 - Contributions are welcome! Please fork the repository and create a pull request with your changes.

## License
 - This project is licensed under the MIT License.
