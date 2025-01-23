@echo off
REM setup.bat - Script di configurazione per il progetto su Windows

REM Verifica se Python è installato
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Python non e' installato. Per favore installalo e riprova.
    exit /b 1
)

REM Verifica se pip è installato
pip --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo pip non e' installato. Installazione in corso...
    python -m ensurepip --upgrade
)

REM Crea un ambiente virtuale chiamato 'env'
python -m venv env

REM Attiva l'ambiente virtuale
CALL env\Scripts\activate.bat

REM Aggiorna pip
python -m pip install --upgrade pip

REM Installa le dipendenze dal requirements.txt
pip install -r requirements.txt

echo Configurazione completata con successo!
echo Per attivare l'ambiente virtuale in futuro, esegui: env\Scripts\activate
