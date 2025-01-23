#!/bin/bash

# setup.sh - Script di configurazione per il progetto

# Verifica se Python 3 è installato
if ! command -v python3 &> /dev/null
then
    echo "Python3 non è installato. Per favore installalo e riprova."
    exit
fi

# Verifica se pip è installato
if ! command -v pip3 &> /dev/null
then
    echo "pip3 non è installato. Installazione in corso..."
    sudo apt-get update
    sudo apt-get install -y python3-pip
fi

# Crea un ambiente virtuale chiamato 'env'
python3 -m venv env

# Attiva l'ambiente virtuale
source env/bin/activate

# Aggiorna pip
pip install --upgrade pip

# Installa le dipendenze dal requirements.txt
pip install -r requirements.txt

echo "Configurazione completata con successo!"
echo "Per attivare l'ambiente virtuale, esegui: source env/bin/activate"
