#!/bin/bash

echo "Starting the openocd instance for the STM32 F411RE..."
echo "Use [Ctrl+C] to quit at any time."

# Start the OpenOCD Server for the STM32 F411RE Nucleo
openocd -f board/st_nucleo_f4.cfg
