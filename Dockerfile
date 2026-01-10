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
    curl \
    wget \
    libncurses5-dev \
    libstdc++6 \
    zlib1g-dev \
    libbz2-dev \
    libssl-dev \
    libreadline-dev \
    libsqlite3-dev \
    tk-dev \
    liblzma-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    libgdbm-dev \
    libncursesw5-dev \
    libsqlite3-dev

# تثبيت Buildozer
RUN pip3 install --upgrade pip && \
    pip3 install buildozer

# تثبيت Android SDK و NDK
RUN mkdir -p /opt/android-sdk/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip /tmp/cmdline-tools.zip -d /opt/android-sdk/cmdline-tools && \
    rm /tmp/cmdline-tools.zip && \
    mkdir -p /opt/android-sdk/cmdline-tools/latest && \
    mv /opt/android-sdk/cmdline-tools/cmdline-tools/* /opt/android-sdk/cmdline-tools/latest/

# تعيين البيئة
ENV ANDROID_HOME=/opt/android-sdk/cmdline-tools/latest
ENV PATH=$ANDROID_HOME/bin:$PATH
ENV ANDROID_SDK_ROOT=$ANDROID_HOME

# قبول تراخيص SDK
RUN yes | /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager --licenses

# تثبيت الأدوات المطلوبة (SDK و NDK)
RUN /opt/android-sdk/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3" "ndk;21.3.6528147"

# تحديد المسار الخاص بالمشروع
WORKDIR /app

# نسخ ملفات المشروع إلى الحاوية
COPY . /app

# تشغيل Buildozer لبناء APK
CMD buildozer android debug
