#!/bin/bash

###############################################################################
#              Script di setup per Google Colab con installazione             #
#                    delle dipendenze da requirements.txt                     #
###############################################################################

# Funzione di comodo per interrompere lo script in caso di errore
function error_exit {
    echo "$1" 1>&2
    exit 1
}

echo "Aggiorno apt-get (opzionale ma utile in Colab per installare pacchetti di sistema)..."
apt-get update -y || error_exit "Impossibile aggiornare i pacchetti di sistema."

echo "Installazione di unzip (se non già presente)..."
apt-get install -y unzip || error_exit "Impossibile installare unzip."

echo "Installazione/aggiornamento di gdown (per scaricare file da Google Drive)..."
pip install --upgrade gdown || error_exit "Impossibile installare gdown."

###############################################################################
#                            INSTALLAZIONE DEPENDENZE                         #
###############################################################################
# Se hai un file requirements.txt con le tue librerie Python, per esempio:
#   Pillow
#   scikit-learn
#   scikit-image
#   matplotlib
# Salvalo nella stessa cartella dello script, oppure fornisci il percorso corretto.

REQ_FILE="/content/AIF24-25/requirements.txt"  # Modifica se il tuo file ha un altro nome o percorso

if [ -f "$REQ_FILE" ]; then
    echo "Trovato $REQ_FILE. Installo le dipendenze Python..."
    pip install -r "$REQ_FILE" || error_exit "Impossibile installare i pacchetti da requirements.txt."
else
    echo "Non ho trovato $REQ_FILE. Skipping Python packages installation."
fi

###############################################################################
#                          SEZIONE DOWNLOAD & UNZIP                            #
###############################################################################
# Qui puoi inserire le operazioni di download ed estrazione.
# Ad esempio, scarichiamo 2 file ZIP da Google Drive e li estraiamo.

DATA_DIR="/content/AIF24-25/data"
mkdir -p "$DATA_DIR" || error_exit "Impossibile creare la directory $DATA_DIR."

TRAIN_DATA_URL="https://drive.google.com/uc?id=1M_Z0WybOwbq3uPJ0Iyc5S5HUvgidIXmb"
TEST_DATA_URL="https://drive.google.com/uc?id=1uM8l24HbZC0_iCeYiqXAFtbHGqhmC5sE"

TRAIN_DATA_ZIP="$DATA_DIR/train_data.zip"
TEST_DATA_ZIP="$DATA_DIR/test_data.zip"

echo "Scaricamento di train_data.zip..."
gdown "$TRAIN_DATA_URL" -O "$TRAIN_DATA_ZIP" || error_exit "Impossibile scaricare train_data.zip."

echo "Scaricamento di test_data.zip..."
gdown "$TEST_DATA_URL" -O "$TEST_DATA_ZIP" || error_exit "Impossibile scaricare test_data.zip."

# Estraggo i file
echo "Estrazione di train_data.zip..."
TEMP_TRAIN="$DATA_DIR/temp_train_data"
mkdir -p "$TEMP_TRAIN"
unzip -o "$TRAIN_DATA_ZIP" -d "$TEMP_TRAIN" || error_exit "Impossibile estrarre train_data.zip."
rm -rf "$TEMP_TRAIN/_MACOSX"

echo "Estrazione di test_data.zip..."
TEMP_TEST="$DATA_DIR/temp_test_data"
mkdir -p "$TEMP_TEST"
unzip -o "$TEST_DATA_ZIP" -d "$TEMP_TEST" || error_exit "Impossibile estrarre test_data.zip."
rm -rf "$TEMP_TEST/_MACOSX"

# Creo le cartelle finali
FINAL_TRAIN="$DATA_DIR/train_data"
FINAL_TEST="$DATA_DIR/test_data"
mkdir -p "$FINAL_TRAIN" "$FINAL_TEST"

# Sposto i file estratti
if [ -d "$TEMP_TRAIN/train_data" ]; then
    mv "$TEMP_TRAIN/train_data"/* "$FINAL_TRAIN" || error_exit "Impossibile spostare i file di train_data."
else
    mv "$TEMP_TRAIN"/* "$FINAL_TRAIN" || error_exit "Impossibile spostare i file estratti di train_data."
fi

if [ -d "$TEMP_TEST/test_data" ]; then
    mv "$TEMP_TEST/test_data"/* "$FINAL_TEST" || error_exit "Impossibile spostare i file di test_data."
else
    mv "$TEMP_TEST"/* "$FINAL_TEST" || error_exit "Impossibile spostare i file estratti di test_data."
fi

# Pulizia file temporanei
rm -rf "$TEMP_TRAIN" "$TEMP_TEST"
rm -f "$TRAIN_DATA_ZIP" "$TEST_DATA_ZIP"

echo "Download ed estrazione completati con successo!"
echo "Struttura finale nella cartella $DATA_DIR:"
echo "  $DATA_DIR/train_data/"
echo "  $DATA_DIR/test_data/"

echo "Setup completato con successo!"
