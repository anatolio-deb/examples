/*
 * SPDX-License-Identifier: GPL-2.0-or-later
 * SPDX-FileCopyrightText: 2023 Your Organization (https://yourwebsite.com)
 */

public class MyApp : Gtk.Application {   
    private string imagesDir;
    private GLib.Settings settings = new GLib.Settings ("org.gnome.desktop.background");
    private Gtk.Picture add_conn_image;

    public MyApp () {
        Object (
            application_id: "io.github.myteam.myapp",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    public override void startup () {
        base.startup ();
        var path = File.new_for_path (Environment.get_home_dir ()).get_child (imagesDir);
        Dir dir = null;

        try{
            if (!path.query_exists () || path.query_file_type (0) != FileType.DIRECTORY) {
                path.create (FileCreateFlags.NONE);
            }else{
                dir = Dir.open (path.get_uri (), 0);
            }
        }catch (Error err) {
            debug(err.message);
            Process.exit (0);
        }

        var loader = new Gdk.PixbufLoader ();
        loader.write (message.response_body.data);
        loader.close ();

        pixbuf = loader.get_pixbuf ();

       
        Gdk.Pixbuf? image_pixbuf = ImageCache.singleton.get_resource_pixbuf(settings.get_string ("picture-uri"));
        if (null != image_pixbuf) {
            image_pixbuf = image_pixbuf.scale_simple(128, 128, Gdk.InterpType.BILINEAR);
            add_conn_image = new Gtk.Picture.for_pixbuf(image_pixbuf);
        } else {
            add_conn_image = new Gtk.Picture.for_resource(settings.get_string ("picture-uri"));
        }
        add_conn_image.width_request = 480;
        add_conn_image.height_request = 300;
        add_conn_image.can_shrink = true;
        add_conn_image.keep_aspect_ratio = true;
    }   

    protected override void activate () {
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);

        var main_window = new Gtk.ApplicationWindow (this) {
            child = box
        };
            
        main_window.present ();
    }

    public static int main (string[] args) {
        return new MyApp ().run (args);
    }
}
