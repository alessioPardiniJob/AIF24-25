@echo off
REM ###########################################################################
REM setup.bat - Project setup script for Windows with debugging
REM
REM Questo script esegue i medesimi passaggi del corrispondente script Bash:
REM   1. Verifica che Python e pip siano disponibili (installando pip se assente).
REM   2. Crea e attiva un ambiente virtuale 'env'.
REM   3. Aggiorna pip e installa le dipendenze da requirements.txt.
REM   4. Installa Jupyter Notebook, crea e registra un kernel chiamato 'env'.
REM   5. Verifica o installa 'gdown' per scaricare file da Google Drive.
REM   6. Scarica e decomprime i dati di train e test, organizzandoli in cartelle.
REM   7. Imposta il notebook per usare il kernel appena creato ('env').
REM ###########################################################################

REM Abilita l'espansione ritardata delle variabili
SETLOCAL ENABLEDELAYEDEXPANSION

REM ============================ INIZIO DEBUGGING ============================
echo ================================================================
echo ============ Inizio esecuzione di setup.bat =================
echo ================================================================
echo.

REM ======================== 1. VERIFICA PYTHON/PIP ===========================
echo ======================== Step 1: Verifica Python =======================
where python >nul 2>&1
if %errorlevel% neq 0 (
    call :ERROR_EXIT "Python3 non è installato. Per favore installalo e riprova."
) else (
    echo Python3 trovato.
)
echo.

echo ======================== Verifica pip ===============================
echo Controllo la versione di pip...
python -m pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo pip non è installato. Provo a installarlo...
    python -m ensurepip --upgrade
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile installare pip. Controlla i permessi e riprova."
    ) else (
        echo pip installato con successo.
    )
) else (
    echo pip è già installato.
)
echo.

REM ======================== 2. CREA E ATTIVA ENV =============================
echo ======================== Step 2: Crea e attiva l'ambiente virtuale 'env' =======================
if not exist "..\env" (
    echo Creazione dell'ambiente virtuale 'env'...
    python -m venv ..\env
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile creare l'ambiente virtuale."
    ) else (
        echo Ambiente virtuale creato.
    )
) else (
    echo L'ambiente virtuale 'env' esiste già.
)
echo.

echo Attivazione dell'ambiente virtuale 'env'...
call "..\env\Scripts\activate.bat"
if %errorlevel% neq 0 (
    call :ERROR_EXIT "Impossibile attivare l'ambiente virtuale."
) else (
    echo Ambiente virtuale attivato.
)
echo.

REM ========================== 3. UPGRADE PIP =================================
echo ======================== Step 3: Aggiorna pip =======================
echo Aggiornamento di pip...
python -m pip install --upgrade pip
if %errorlevel% neq 0 (
    call :ERROR_EXIT "Impossibile aggiornare pip."
) else (
    echo pip aggiornato con successo.
)
echo.

REM =========== 4. INSTALLA REQUIREMENTS + NOTEBOOK + KERNEL ==================
echo ======================== Step 4: Installa dipendenze =======================
if exist "..\requirements.txt" (
    echo Installazione delle dipendenze da requirements.txt...
    python -m pip install -r "..\requirements.txt"
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile installare le dipendenze dal requirements.txt."
    ) else (
        echo Dipendenze installate con successo.
    )
) else (
    call :ERROR_EXIT "Il file requirements.txt non esiste."
)
echo.

echo Installazione di Jupyter Notebook...
python -m pip install notebook
if %errorlevel% neq 0 (
    call :ERROR_EXIT "Impossibile installare Jupyter Notebook."
) else (
    echo Jupyter Notebook installato con successo.
)
echo.

echo Installazione di ipykernel e nbformat...
python -m pip install ipykernel nbformat
if %errorlevel% neq 0 (
    call :ERROR_EXIT "Impossibile installare ipykernel o nbformat."
) else (
    echo ipykernel e nbformat installati con successo.
)
echo.

echo Registrazione del kernel 'env' in Jupyter...
python -m ipykernel install --user --name=env --display-name="Python (env)"
if %errorlevel% neq 0 (
    call :ERROR_EXIT "Impossibile registrare il kernel Jupyter."
) else (
    echo Kernel 'env' registrato con successo.
)
echo.

echo Dipendenze installate con successo!
echo.
REM =========================== 5. VERIFICA GDOWN ==========================
echo ======================== Step 5: Verifica o installa gdown =======================

REM 1. Verifica se gdown è installato tramite pip
pip show gdown >nul 2>&1
if errorlevel 1 (
    echo gdown non è installato. Installazione in corso...
    pip install gdown
    if errorlevel 1 (
        call :ERROR_EXIT "Impossibile installare gdown tramite pip o gdown non è importabile."
    ) else (
        echo gdown installato con successo.
        REM Verifica se gdown è importabile in Python
        python -c "import gdown" >nul 2>&1
        if errorlevel 1 (
            call :ERROR_EXIT "gdown è stato installato ma non è importabile in Python."
        ) else (
            echo gdown è importabile in Python.
        )
    )
) else (
    echo gdown è già installato.
    REM Verifica se gdown è importabile in Python
    python -c "import gdown" >nul 2>&1
    if errorlevel 1 (
        call :ERROR_EXIT "gdown è installato ma non è importabile in Python."
    ) else (
        echo gdown è importabile in Python.
    )
)

echo.
REM ====================== Fine Step 5 gdown =========================

REM ========================== 6. DOWNLOAD & UNZIP ============================
echo ======================== Step 6: Download e decompressione dei dati =======================
set TRAIN_DATA_URL=https://drive.google.com/uc?id=1M_Z0WybOwbq3uPJ0Iyc5S5HUvgidIXmb
set TEST_DATA_URL=https://drive.google.com/uc?id=1uM8l24HbZC0_iCeYiqXAFtbHGqhmC5sE
set TRAIN_DATA_ZIP=.\train_data.zip
set TEST_DATA_ZIP=.\test_data.zip

echo Scaricamento di train_data.zip...
gdown %TRAIN_DATA_URL% -O %TRAIN_DATA_ZIP%
if %errorlevel% neq 0 (
    call :ERROR_EXIT "Impossibile scaricare train_data.zip."
) else (
    echo train_data.zip scaricato con successo.
)
echo.

echo Scaricamento di test_data.zip...
gdown %TEST_DATA_URL% -O %TEST_DATA_ZIP%
if %errorlevel% neq 0 (
    call :ERROR_EXIT "Impossibile scaricare test_data.zip."
) else (
    echo test_data.zip scaricato con successo.
)
echo.

echo Download completati con successo!
echo.

set DATA_DIR=..\data
echo Creazione della directory %DATA_DIR% se non esiste...
if not exist "%DATA_DIR%" (
    mkdir "%DATA_DIR%"
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile creare la directory %DATA_DIR%."
    ) else (
        echo Directory %DATA_DIR% creata.
    )
) else (
    echo La directory %DATA_DIR% esiste già.
)
echo.

echo Verifica della disponibilità di PowerShell...
where powershell >nul 2>&1
if %errorlevel% neq 0 (
    call :ERROR_EXIT "PowerShell non è disponibile. Non posso estrarre i file .zip."
) else (
    echo PowerShell è disponibile.
)
echo.

REM ========================== Estrazione train_data ==========================
echo ======================== Estrazione di train_data.zip =======================
echo Estrazione di train_data.zip...
set TEMP_TRAIN=%DATA_DIR%\temp_train_data
if not exist "%TEMP_TRAIN%" (
    echo Creazione della directory temporanea %TEMP_TRAIN%...
    mkdir "%TEMP_TRAIN%"
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile creare la directory temporanea %TEMP_TRAIN%."
    ) else (
        echo Directory temporanea %TEMP_TRAIN% creata.
    )
) else (
    echo Directory temporanea %TEMP_TRAIN% esiste già.
)
echo.

echo Estrazione di train_data.zip in %TEMP_TRAIN%...
powershell -Command "Expand-Archive -Path '%TRAIN_DATA_ZIP%' -DestinationPath '%TEMP_TRAIN%' -Force"
if %errorlevel% neq 0 (
    call :ERROR_EXIT "Impossibile estrarre train_data.zip."
) else (
    echo train_data.zip estratto con successo.
)
echo.

if exist "%TEMP_TRAIN%\_MACOSX" (
    echo Rimozione della directory _MACOSX...
    rmdir /s /q "%TEMP_TRAIN%\_MACOSX"
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile rimuovere la directory _MACOSX."
    ) else (
        echo Directory _MACOSX rimossa.
    )
) else (
    echo Nessuna directory _MACOSX trovata.
)
echo.

set FINAL_TRAIN=%DATA_DIR%\train_data
echo Creazione della directory finale %FINAL_TRAIN%...
if not exist "%FINAL_TRAIN%" (
    mkdir "%FINAL_TRAIN%"
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile creare la directory %FINAL_TRAIN%."
    ) else (
        echo Directory %FINAL_TRAIN% creata.
    )
) else (
    echo La directory %FINAL_TRAIN% esiste già.
)
echo.

if exist "%TEMP_TRAIN%\train_data" (
    echo Spostamento dei file da %TEMP_TRAIN%\train_data a %FINAL_TRAIN%...
    move "%TEMP_TRAIN%\train_data\*" "%FINAL_TRAIN%"
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile spostare i file di train_data."
    ) else (
        echo File di train_data spostati con successo.
    )
) else (
    echo Spostamento dei file da %TEMP_TRAIN% a %FINAL_TRAIN%...
    move "%TEMP_TRAIN%\*" "%FINAL_TRAIN%"
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile spostare i file estratti di train_data."
    ) else (
        echo File estratti di train_data spostati con successo.
    )
)
echo.

echo Rimozione della directory temporanea %TEMP_TRAIN%...
rmdir /s /q "%TEMP_TRAIN%"
if %errorlevel% neq 0 (
    call :ERROR_EXIT "Impossibile rimuovere la directory temporanea %TEMP_TRAIN%."
) else (
    echo Directory temporanea rimossa.
)
echo.

REM =========================== Estrazione test_data ==========================
echo ======================== Estrazione di test_data.zip =======================
echo Estrazione di test_data.zip...
set TEMP_TEST=%DATA_DIR%\temp_test_data
if not exist "%TEMP_TEST%" (
    echo Creazione della directory temporanea %TEMP_TEST%...
    mkdir "%TEMP_TEST%"
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile creare la directory temporanea %TEMP_TEST%."
    ) else (
        echo Directory temporanea %TEMP_TEST% creata.
    )
) else (
    echo Directory temporanea %TEMP_TEST% esiste già.
)
echo.

echo Estrazione di test_data.zip in %TEMP_TEST%...
powershell -Command "Expand-Archive -Path '%TEST_DATA_ZIP%' -DestinationPath '%TEMP_TEST%' -Force"
if %errorlevel% neq 0 (
    call :ERROR_EXIT "Impossibile estrarre test_data.zip."
) else (
    echo test_data.zip estratto con successo.
)
echo.

if exist "%TEMP_TEST%\_MACOSX" (
    echo Rimozione della directory _MACOSX...
    rmdir /s /q "%TEMP_TEST%\_MACOSX"
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile rimuovere la directory _MACOSX."
    ) else (
        echo Directory _MACOSX rimossa.
    )
) else (
    echo Nessuna directory _MACOSX trovata.
)
echo.

set FINAL_TEST=%DATA_DIR%\test_data
echo Creazione della directory finale %FINAL_TEST%...
if not exist "%FINAL_TEST%" (
    mkdir "%FINAL_TEST%"
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile creare la directory %FINAL_TEST%."
    ) else (
        echo Directory %FINAL_TEST% creata.
    )
) else (
    echo La directory %FINAL_TEST% esiste già.
)
echo.

if exist "%TEMP_TEST%\test_data" (
    echo Spostamento dei file da %TEMP_TEST%\test_data a %FINAL_TEST%...
    move "%TEMP_TEST%\test_data\*" "%FINAL_TEST%"
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile spostare i file di test_data."
    ) else (
        echo File di test_data spostati con successo.
    )
) else (
    echo Spostamento dei file da %TEMP_TEST% a %FINAL_TEST%...
    move "%TEMP_TEST%\*" "%FINAL_TEST%"
    if %errorlevel% neq 0 (
        call :ERROR_EXIT "Impossibile spostare i file estratti di test_data."
    ) else (
        echo File estratti di test_data spostati con successo.
    )
)
echo.

echo Rimozione della directory temporanea %TEMP_TEST%...
rmdir /s /q "%TEMP_TEST%"
if %errorlevel% neq 0 (
    call :ERROR_EXIT "Impossibile rimuovere la directory temporanea %TEMP_TEST%."
) else (
    echo Directory temporanea rimossa.
)
echo.

echo Eliminazione dei file ZIP...
del "%TRAIN_DATA_ZIP%" "%TEST_DATA_ZIP%" >nul 2>&1
if %errorlevel% neq 0 (
    echo Attenzione: impossibile rimuovere i file zip.
) else (
    echo File zip rimossi con successo.
)
echo.

echo Estrazione completata con successo!
echo Struttura finale nella cartella %DATA_DIR%:
echo   %DATA_DIR%\train_data\
echo   %DATA_DIR%\test_data\
echo.

echo Configurazione completata con successo!
echo.

REM ==================== 7. FORZA IL NOTEBOOK AD USARE 'env' =================
echo ======================== Step 7: Aggiorna il kernel del notebook =======================
set NOTEBOOK_PATH=C:\disk4\alessioPardini\TEST1\AIF24-25\notebook\PardiniAIF24-25.ipynb

echo Imposto il notebook a usare il kernel 'env'...

REM Crea un file Python temporaneo
set TEMP_PYTHON_SCRIPT=%TEMP%\update_kernel.py
echo Creazione del file Python temporaneo %TEMP_PYTHON_SCRIPT%...
(
    echo import nbformat
    echo nb_path = r"%NOTEBOOK_PATH%"
    echo nb = nbformat.read(nb_path, as_version=4)
    echo nb['metadata']['kernelspec'] = {
    echo ^'display_name^': ^'Python (env)^',
    echo ^'language^': ^'python^',
    echo ^'name^': ^'env^'
    echo }
    echo nbformat.write(nb, nb_path)
) > "%TEMP_PYTHON_SCRIPT%"

if %errorlevel% neq 0 (
    call :ERROR_EXIT "Impossibile creare lo script Python temporaneo."
) else (
    echo File Python temporaneo creato.
)
echo.

REM Esegui lo script Python temporaneo
echo Esecuzione dello script Python temporaneo...
python "%TEMP_PYTHON_SCRIPT%"
if %errorlevel% neq 0 (
    echo Errore durante l'esecuzione dello script Python.
    del "%TEMP_PYTHON_SCRIPT%"
    call :ERROR_EXIT "Impossibile aggiornare il notebook per usare il kernel 'env'."
) else (
    echo Notebook aggiornato con successo per usare il kernel 'env'.
)

REM Elimina il file Python temporaneo
echo Eliminazione del file Python temporaneo...
del "%TEMP_PYTHON_SCRIPT%"
if %errorlevel% neq 0 (
    echo Attenzione: impossibile rimuovere il file Python temporaneo.
) else (
    echo File Python temporaneo rimosso.
)
echo.

echo Operazione completata. Premi un tasto per chiudere...
pause >nul
exit /b 0

REM ============================ FUNZIONE DI USCITA ============================
:ERROR_EXIT
echo ================================================================
echo ERRORE: %~1
echo Script interrotto. Premi un tasto per chiudere...
echo ================================================================
echo.
pause >nul
exit /b 1
