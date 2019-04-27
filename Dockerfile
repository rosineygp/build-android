FROM openjdk:8

ENV SDK_HOME /usr/local
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q -y && \ 
    apt-get install -q --yes wget tar unzip lib32stdc++6 lib32z1 git ruby-dev build-essential --no-install-recommends && \
    gem install fastlane && \
    apt-get remove build-essential -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

ENV ANDROID_SDK_URL https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
ENV ANDROID_BUILD_TOOLS="28.0.3"

RUN curl -ksSL "${ANDROID_SDK_URL}" -o android-sdk-linux.zip \
    && unzip -q android-sdk-linux.zip -d android-sdk-linux \
    && rm -rf android-sdk-linux.zip

ENV ANDROID_HOME $PWD/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:$PATH

RUN mkdir $ANDROID_HOME/licenses
RUN echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > $ANDROID_HOME/licenses/android-sdk-license
RUN echo d56f5187479451eabf01fb78af6dfcb131a6481e >> $ANDROID_HOME/licenses/android-sdk-license
RUN echo 84831b9409646a918e30573bab4c9c91346d8abd > $ANDROID_HOME/licenses/android-sdk-preview-license

RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager "tools" "platform-tools" > /dev/null
RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" > /dev/null
RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-21" > /dev/null
RUN echo yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-28" > /dev/null