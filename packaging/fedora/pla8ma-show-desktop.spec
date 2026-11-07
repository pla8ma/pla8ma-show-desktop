# Builds the newest state of the main branch:
#   sudo dnf install rpm-build rpmdevtools gettext
#   spectool -g -R pla8ma-show-desktop.spec
#   rpmbuild -bb pla8ma-show-desktop.spec
#   sudo dnf install ~/rpmbuild/RPMS/noarch/pla8ma-show-desktop-*.rpm

# .copr/Makefile fixes buildstamp to the time the source RPM is made, so
# every rebuild is an update for dnf.
%global buildstamp %(date -u +%Y%m%d%H%M)
%global applet io.github.pla8ma.showdesktop

Name:           pla8ma-show-desktop
Version:        1.0
Release:        %{buildstamp}%{?dist}
Summary:        Pla8ma show desktop widget for KDE Plasma
License:        GPL-2.0-or-later
URL:            https://github.com/pla8ma/pla8ma-show-desktop
Source0:        %{url}/archive/refs/heads/main.tar.gz#/%{name}-main.tar.gz
BuildArch:      noarch

BuildRequires:  gettext

Requires:       plasma-workspace >= 6.0
Requires:       libplasma
Requires:       kf6-kwindowsystem
Requires:       kf6-kirigami
Requires:       kf6-kcmutils

%description
A show desktop button for KDE Plasma 6 panels: a narrow strip at the very
end of the panel that reaches across its full height. A click shows the
desktop or brings the windows back. Optionally it peeks at the desktop
while the pointer rests on it. Meant for the Pla8ma panel.

%prep
%autosetup -n %{name}-main

%build
msgfmt po/de.po -o plasma_applet_%{applet}.mo

%install
mkdir -p %{buildroot}%{_datadir}/plasma/plasmoids/%{applet}
cp -a plasmoid/. %{buildroot}%{_datadir}/plasma/plasmoids/%{applet}/
install -Dm644 plasma_applet_%{applet}.mo \
    %{buildroot}%{_datadir}/locale/de/LC_MESSAGES/plasma_applet_%{applet}.mo
%find_lang plasma_applet_%{applet}

%files -f plasma_applet_%{applet}.lang
%license LICENSES/GPL-2.0-or-later.txt
%doc README.md
%{_datadir}/plasma/plasmoids/%{applet}/

%changelog
* Sun Nov 08 2026 Pla8ma <johndoe@example.com>
- Version 1.0
