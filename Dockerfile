FROM archlinux 

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
RUN pacman -Sy wget --noconfirm
RUN wget https://america.mirror.pkgbuild.com/core/os/x86_64/icu-71.1-1-x86_64.pkg.tar.zst
RUN pacman -U icu-71.1-1-x86_64.pkg.tar.zst --noconfirm
RUN groupadd user 
RUN useradd -G user tijko
WORKDIR /home/tijko
RUN chown tijko:user /home/tijko
USER tijko
RUN mkdir Agent
WORKDIR Agent
# Patching of the Microsoft Agent config.sh script might be neccessary.
RUN curl https://vstsagentpackage.azureedge.net/agent/2.181.2/vsts-agent-linux-x64-2.181.2.tar.gz --output agent.tar.gz
RUN tar -xzvf agent.tar.gz 
RUN ./config.sh --unattended \
  --agent "Local-Linux-Agent" \
  --url "https://tkonick-lt2" \
  --auth PAT \
  --token "bawvcnds25x4guwfpxgwjiwj5b57ahcd7pust2r5tnyq3dfoyhaq" \
  --pool "Default" \
  --work "_work" \
  --acceptTeeEula --replace & wait $!

CMD ./run.sh
