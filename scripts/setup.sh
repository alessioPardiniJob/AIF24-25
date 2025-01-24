#!/bin/bash

# setup.sh - Script di configurazione per il progetto

function error_exit {
    echo "$1" 1>&2
    echo "Script interrotto. Premi un tasto per chiudere..."
    read
    exit 1
}

# Verifica se Python 3 è installato
if ! command -v python3 &> /dev/null
then
    error_exit "Python3 non è installato. Per favore installalo e riprova."
fi

# Verifica se pip3 è installato
if ! command -v pip3 &> /dev/null
then
    echo "pip3 non è installato. Installazione in corso..."
    sudo apt-get update || error_exit "Impossibile aggiornare i pacchetti. Verifica la tua connessione a internet."
    sudo apt-get install -y python3-pip || error_exit "Impossibile installare pip3. Controlla i permessi e riprova."
fi

# Crea un ambiente virtuale chiamato 'env' se non esiste già
if [ ! -d "../env" ]; then
    python3 -m venv ../env || error_exit "Impossibile creare l'ambiente virtuale."
    echo "Ambiente virtuale creato."
else
    echo "L'ambiente virtuale 'env' esiste già."
fi

# Attiva l'ambiente virtuale
source ../env/bin/activate || error_exit "Impossibile attivare l'ambiente virtuale."

# Aggiorna pip
pip install --upgrade pip || error_exit "Impossibile aggiornare pip."

# Installa le dipendenze dal requirements.txt
if [ -f "../requirements.txt" ]; then
    pip install -r ../requirements.txt || error_exit "Impossibile installare le dipendenze dal requirements.txt."
else
    error_exit "Il file requirements.txt non esiste."
fi

# Installa Jupyter Notebook
pip install notebook || error_exit "Impossibile installare jupyter notebook."

# Installa ipykernel e registra il kernel 'env'
pip install ipykernel nbformat || error_exit "Impossibile installare ipykernel o nbformat."
python -m ipykernel install --user --name=env --display-name "Python (env)" || error_exit "Impossibile registrare il kernel Jupyter."

echo "Dipendenze installate con successo!"

# Verifica se gdown è installato, altrimenti installalo
if ! command -v gdown &> /dev/null
then
    echo "gdown non è installato. Installazione in corso per scaricare i dati..."
    pip install gdown || error_exit "Impossibile installare gdown."
fi

###############################################################################
#                          SEZIONE DOWNLOAD & UNZIP                           #
###############################################################################

# URL dei file da scaricare
TRAIN_DATA_URL="https://drive.google.com/uc?id=1M_Z0WybOwbq3uPJ0Iyc5S5HUvgidIXmb"
TEST_DATA_URL="https://drive.google.com/uc?id=1uM8l24HbZC0_iCeYiqXAFtbHGqhmC5sE"

# Nome dei file ZIP
TRAIN_DATA_ZIP="./train_data.zip"
TEST_DATA_ZIP="./test_data.zip"

# Scarica train_data.zip
echo "Scaricamento di train_data.zip..."
gdown "$TRAIN_DATA_URL" -O "$TRAIN_DATA_ZIP" || error_exit "Impossibile scaricare train_data.zip."

# Scarica test_data.zip
echo "Scaricamento di test_data.zip..."
gdown "$TEST_DATA_URL" -O "$TEST_DATA_ZIP" || error_exit "Impossibile scaricare test_data.zip."

echo "Download completati con successo!"

# Crea la directory ../data se non esiste
DATA_DIR="../data"
mkdir -p "$DATA_DIR" || error_exit "Impossibile creare la directory $DATA_DIR."

# Verifica se unzip è installato, altrimenti installalo
if ! command -v unzip &> /dev/null
then
    echo "unzip non è installato. Installazione in corso..."
    sudo apt-get install -y unzip || error_exit "Impossibile installare unzip."
fi

############################
#   Estrazione train_data  #
############################
echo "Estrazione di train_data.zip..."

TEMP_TRAIN="$DATA_DIR/temp_train_data"
mkdir -p "$TEMP_TRAIN"
unzip -o "$TRAIN_DATA_ZIP" -d "$TEMP_TRAIN" || error_exit "Impossibile estrarre train_data.zip."
rm -rf "$TEMP_TRAIN/_MACOSX"

FINAL_TRAIN="$DATA_DIR/train_data"
mkdir -p "$FINAL_TRAIN"

if [ -d "$TEMP_TRAIN/train_data" ]; then
    mv "$TEMP_TRAIN/train_data"/* "$FINAL_TRAIN" || error_exit "Impossibile spostare i file di train_data."
else
    mv "$TEMP_TRAIN"/* "$FINAL_TRAIN" || error_exit "Impossibile spostare i file estratti di train_data."
fi

rm -rf "$TEMP_TRAIN"

############################
#   Estrazione test_data   #
############################
echo "Estrazione di test_data.zip..."

TEMP_TEST="$DATA_DIR/temp_test_data"
mkdir -p "$TEMP_TEST"
unzip -o "$TEST_DATA_ZIP" -d "$TEMP_TEST" || error_exit "Impossibile estrarre test_data.zip."
rm -rf "$TEMP_TEST/_MACOSX"

FINAL_TEST="$DATA_DIR/test_data"
mkdir -p "$FINAL_TEST"

if [ -d "$TEMP_TEST/test_data" ]; then
    mv "$TEMP_TEST/test_data"/* "$FINAL_TEST" || error_exit "Impossibile spostare i file di test_data."
else
    mv "$TEMP_TEST"/* "$FINAL_TEST" || error_exit "Impossibile spostare i file estratti di test_data."
fi

rm -rf "$TEMP_TEST"

############################
#   Pulizia file ZIP       #
############################
rm -f "$TRAIN_DATA_ZIP" "$TEST_DATA_ZIP" || echo "Attenzione: impossibile rimuovere i file zip."

echo "Estrazione completata con successo!"
echo "Struttura finale nella cartella $DATA_DIR:"
echo "  $DATA_DIR/train_data/"
echo "  $DATA_DIR/test_data/"

echo "Configurazione completata con successo!"

###############################################################################
#                      FORZA IL NOTEBOOK AD USARE IL KERNEL 'env'             #
###############################################################################
NOTEBOOK_PATH="/disk4/alessioPardini/TEST1/AIF24-25/notebook/PardiniAIF24-25.ipynb"

echo "Imposto il notebook a usare il kernel 'env'..."
python - <<EOF
import nbformat

nb_path = r"$NOTEBOOK_PATH"
nb = nbformat.read(nb_path, as_version=4)

# Aggiorna la sezione 'kernelspec' nei metadati
nb['metadata']['kernelspec'] = {
    'display_name': 'Python (env)',
    'language': 'python',
    'name': 'env'
}

nbformat.write(nb, nb_path)
EOF

# Avvia Jupyter Notebook aprendo direttamente il file
echo "Avvio di Jupyter Notebook con il kernel 'env'..."
jupyter notebook "$NOTEBOOK_PATH"

# Se preferisci eseguire automaticamente il notebook (senza aprire l'interfaccia grafica), 
# puoi usare nbconvert per “lanciare” il codice del notebook:
# jupyter nbconvert --to notebook --execute --inplace --ExecutePreprocessor.kernel_name=env "$NOTEBOOK_PATH"

# Fine script
