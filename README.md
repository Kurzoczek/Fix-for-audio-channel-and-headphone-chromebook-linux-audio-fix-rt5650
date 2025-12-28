# Chromebook Linux Audio Fix (Realtek RT5650)

A lightweight system service to fix automatic headphone/speaker switching on Chromebooks running Linux (Ubuntu, Debian, Arch, etc.) with the **sof-rt5650** sound card.

## The Problem
On many Chromebooks (like Acer Chromebook 11/14/15), the Linux kernel fails to route audio correctly between the internal speakers and the headphone jack. While the hardware is capable, the digital mixer paths often remain muted or misconfigured after unplugging headphones.

## The Solution
This project provides a background bash script and a systemd service that:
1. Monitors the physical state of the Headphone Jack.
2. Automatically re-initializes the ALSA mixer paths (DAC1, IF1, Stereo Mixers).
3. Ensures a clean transition between outputs without "ghost" audio or pops.

## Installation

### 1. Prerequisites
Ensure you have `alsa-utils` and `wireplumber` installed:
```bash
sudo apt update && sudo apt install alsa-utils wireplumber
