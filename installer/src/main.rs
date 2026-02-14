use gtk4::prelude::*;
use gtk4::{Application, ApplicationWindow, Box, Button, Label, Orientation, Entry, ComboBoxText};
use libadwaita as adw;
use std::process::Command;

const APP_ID: &str = "com.sunriseos.installer";

fn main() {
    adw::init().unwrap();
    
    let app = Application::builder()
        .application_id(APP_ID)
        .build();

    app.connect_activate(build_ui);
    app.run();
}

fn build_ui(app: &Application) {
    let window = ApplicationWindow::builder()
        .application(app)
        .title("SunriseOS Installer")
        .default_width(600)
        .default_height(500)
        .build();

    let main_box = Box::new(Orientation::Vertical, 20);
    main_box.set_margin_top(20);
    main_box.set_margin_bottom(20);
    main_box.set_margin_start(20);
    main_box.set_margin_end(20);

    // Заголовок
    let title = Label::new(Some("Установка SunriseOS"));
    title.add_css_class("title-1");
    main_box.append(&title);

    let subtitle = Label::new(Some("Простой установщик системы"));
    subtitle.add_css_class("dim-label");
    main_box.append(&subtitle);

    // Выбор диска
    let disk_label = Label::new(Some("Выберите диск для установки:"));
    disk_label.set_halign(gtk4::Align::Start);
    main_box.append(&disk_label);

    let disk_combo = ComboBoxText::new();
    disk_combo.append_text("/dev/sda");
    disk_combo.append_text("/dev/nvme0n1");
    disk_combo.append_text("/dev/vda");
    disk_combo.set_active(Some(0));
    main_box.append(&disk_combo);

    // Имя пользователя
    let user_label = Label::new(Some("Имя пользователя:"));
    user_label.set_halign(gtk4::Align::Start);
    main_box.append(&user_label);

    let user_entry = Entry::new();
    user_entry.set_placeholder_text(Some("username"));
    main_box.append(&user_entry);

    // Пароль
    let pass_label = Label::new(Some("Пароль:"));
    pass_label.set_halign(gtk4::Align::Start);
    main_box.append(&pass_label);

    let pass_entry = Entry::new();
    pass_entry.set_placeholder_text(Some("password"));
    pass_entry.set_visibility(false);
    main_box.append(&pass_entry);

    // Hostname
    let host_label = Label::new(Some("Имя компьютера:"));
    host_label.set_halign(gtk4::Align::Start);
    main_box.append(&host_label);

    let host_entry = Entry::new();
    host_entry.set_placeholder_text(Some("sunriseos"));
    host_entry.set_text("sunriseos");
    main_box.append(&host_entry);

    // Кнопки
    let button_box = Box::new(Orientation::Horizontal, 10);
    button_box.set_halign(gtk4::Align::End);

    let cancel_btn = Button::with_label("Отмена");
    cancel_btn.connect_clicked(move |_| {
        std::process::exit(0);
    });
    button_box.append(&cancel_btn);

    let install_btn = Button::with_label("Установить");
    install_btn.add_css_class("suggested-action");
    
    let disk_combo_clone = disk_combo.clone();
    let user_entry_clone = user_entry.clone();
    let pass_entry_clone = pass_entry.clone();
    let host_entry_clone = host_entry.clone();
    
    install_btn.connect_clicked(move |btn| {
        btn.set_sensitive(false);
        
        let disk = disk_combo_clone.active_text().unwrap().to_string();
        let username = user_entry_clone.text().to_string();
        let password = pass_entry_clone.text().to_string();
        let hostname = host_entry_clone.text().to_string();
        
        if username.is_empty() || password.is_empty() {
            eprintln!("Заполните все поля!");
            btn.set_sensitive(true);
            return;
        }
        
        // Запуск установки
        std::thread::spawn(move || {
            install_system(&disk, &username, &password, &hostname);
        });
    });
    
    button_box.append(&install_btn);
    main_box.append(&button_box);

    window.set_child(Some(&main_box));
    window.present();
}

fn install_system(disk: &str, username: &str, password: &str, hostname: &str) {
    println!("Начинаем установку на {}", disk);
    println!("Пользователь: {}", username);
    println!("Hostname: {}", hostname);
    
    // Разметка диска
    let _ = Command::new("parted")
        .args(&["-s", disk, "mklabel", "gpt"])
        .output();
    
    let _ = Command::new("parted")
        .args(&["-s", disk, "mkpart", "ESP", "fat32", "1MiB", "512MiB"])
        .output();
    
    let _ = Command::new("parted")
        .args(&["-s", disk, "set", "1", "esp", "on"])
        .output();
    
    let _ = Command::new("parted")
        .args(&["-s", disk, "mkpart", "primary", "ext4", "512MiB", "100%"])
        .output();
    
    // Форматирование
    let boot_part = format!("{}1", disk);
    let root_part = format!("{}2", disk);
    
    let _ = Command::new("mkfs.fat")
        .args(&["-F32", &boot_part])
        .output();
    
    let _ = Command::new("mkfs.ext4")
        .args(&["-F", &root_part])
        .output();
    
    // Монтирование
    let _ = Command::new("mount")
        .args(&[&root_part, "/mnt"])
        .output();
    
    let _ = Command::new("mkdir")
        .args(&["-p", "/mnt/boot"])
        .output();
    
    let _ = Command::new("mount")
        .args(&[&boot_part, "/mnt/boot"])
        .output();
    
    // Установка базовой системы
    let _ = Command::new("pacstrap")
        .args(&["/mnt", "base", "linux", "linux-firmware", "grub", "efibootmgr", "networkmanager", "gnome", "gdm"])
        .output();
    
    // Генерация fstab
    let _ = Command::new("sh")
        .args(&["-c", "genfstab -U /mnt >> /mnt/etc/fstab"])
        .output();
    
    // Настройка системы через chroot
    let chroot_script = format!(
        r#"
        ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
        hwclock --systohc
        echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
        echo 'ru_RU.UTF-8 UTF-8' >> /etc/locale.gen
        locale-gen
        echo 'LANG=ru_RU.UTF-8' > /etc/locale.conf
        echo '{}' > /etc/hostname
        useradd -m -G wheel -s /bin/bash {}
        echo '{}:{}' | chpasswd
        echo 'root:root' | chpasswd
        sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
        systemctl enable NetworkManager
        systemctl enable gdm
        grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
        grub-mkconfig -o /boot/grub/grub.cfg
        "#,
        hostname, username, username, password
    );
    
    let _ = Command::new("arch-chroot")
        .args(&["/mnt", "sh", "-c", &chroot_script])
        .output();
    
    println!("Установка завершена!");
    println!("Перезагрузите систему.");
}
