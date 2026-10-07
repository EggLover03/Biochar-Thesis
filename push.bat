@echo off
rem Stage everything, commit, sync with the remote, then push.
rem Usage: push.bat "your commit message"   (or just double-click and type the message)

cd /d "%~dp0"

git add -A
git diff --cached --quiet
if errorlevel 1 goto commit
echo Nothing new to commit, syncing with the remote only.
goto sync

:commit
set "MSG=%~1"
if defined MSG goto do_commit
set /p "MSG=Commit message: "
if not defined MSG (
  echo No commit message given, aborting.
  pause
  exit /b 1
)

:do_commit
git commit -m "%MSG%"
if errorlevel 1 (
  pause
  exit /b 1
)

:sync
rem Pull first so the push is not rejected if the other collaborator pushed in the meantime.
git pull --rebase
if errorlevel 1 (
  echo.
  echo Pull failed or hit a conflict. Resolve it, then run this again.
  pause
  exit /b 1
)

git push
if errorlevel 1 (
  pause
  exit /b 1
)

echo.
echo Done.
pause
