# استخدام صورة Ubuntu كقاعدة
FROM ubuntu:latest

# تثبيت الأدوات الأساسية
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    openjdk-8-jdk \
    build-essential \
    git \
    unzip \
    curl

# تثبيت Buildozer واعتماده
RUN pip3 install --upgrade pip && \
    pip3 install buildozer

# تثبيت Android SDK و NDK
RUN curl -o android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip && \
    unzip android-sdk.zip -d /opt/android-sdk-linux && \
    rm android-sdk.zip

# تعيين البيئة
ENV ANDROID_HOME=/opt/android-sdk-linux
ENV PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH

# تثبيت SDK و NDK
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3" "ndk;21.3.6528147"

# تحديد المسار الخاص بالمشروع
WORKDIR /app
