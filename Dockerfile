# Dockerfile - Buildozer + Android command-line tools (Ubuntu 22.04)
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:/opt/venv/bin:$PATH

# أدوات النظام اللازمة
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-venv python3-pip openjdk-11-jdk build-essential git unzip curl wget zip \
    libncurses5-dev zlib1g-dev libbz2-dev libssl-dev libreadline-dev libsqlite3-dev tk-dev \
    liblzma-dev libxml2-dev libxmlsec1-dev libffi-dev libgdbm-dev libncursesw5-dev procps \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Python venv و Buildozer
RUN python3 -m venv /opt/venv
RUN /opt/venv/bin/pip install --upgrade pip setuptools wheel
RUN /opt/venv/bin/pip install buildozer cython

# تنزيل Android command-line tools (نسخة محددة كما في المثال السابق)
RUN mkdir -p /opt/android-sdk/cmdline-tools
WORKDIR /opt/android-sdk/cmdline-tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O cmdline-tools.zip \
    && unzip cmdline-tools.zip \
    && mv cmdline-tools latest \
    && rm cmdline-tools.zip

# ضمان وجود مجلدات SDK الأساسية
RUN mkdir -p ${ANDROID_SDK_ROOT}/platforms ${ANDROID_SDK_ROOT}/platform-tools ${ANDROID_SDK_ROOT}/build-tools

# قبول التراخيص وتثبيت المكونات المطلوبة
# ملاحظة: الأمر sdkmanager يصبح متاحًا بعد وضع cmdline-tools في PATH (محدد في ENV أعلاه)
RUN yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses || true
RUN $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "platforms;android-31" "build-tools;31.0.0" "ndk;25.2.9519653"

# مجلد العمل لنسخ المشروع
WORKDIR /app

# انسخ كل شيء (أو عدّل COPY ليكون أكثر انتقائية إذا رغبت)
COPY . /app

# لا نغيّر المستخدم: نترك root ليتماشى مع mounts على GitHub Actions
# نضع شل افتراضي لتشغيل أوامر داخل الحاوية
ENTRYPOINT ["bash", "-lc"]

