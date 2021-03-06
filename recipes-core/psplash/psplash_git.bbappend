FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
FILESEXTRAPATHS_prepend := "${THISDIR}/patches:"
SPLASH_IMAGES_append_rpi = " file://psplash-poky-img.h;outsuffix=dynasystem"
ALTERNATIVE_PRIORITY_psplash-raspberrypi[psplash] = "1"

inherit systemd

SRC_URI += "file://psplash.service \
						file://0001-CONFIGS-custom-centered-image.patch"
SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "psplash.service"

pkg_postinst_${PN} () {
  if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
    if [ -n "$D" ]; then
      OPTS="--root=$D"
    fi
    systemctl $OPTS unmask psplash.service
  fi
}

do_install_append() {
	install -d ${D}${systemd_system_unitdir}
	install -m 0700 ${WORKDIR}/psplash.service ${D}${systemd_system_unitdir}
}

FILES_${PN} += "${systemd_system_unitdir}/psplash.service"
