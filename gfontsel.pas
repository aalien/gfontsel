program gfontsel;

uses cmem, gtk2, gdk2, glib2, strings;

	var
		clipboard_x: PGtkClipboard;
		clipboard_gtk: PGtkClipboard;
		fontdialog: PGtkWidget;
		
	procedure CopyToClipboard;
	var
		fontname: PgChar;
	begin
		fontname :=  gtk_font_selection_dialog_get_font_name(GTK_FONT_SELECTION_DIALOG(fontdialog));
		g_print(fontname);
		gtk_clipboard_clear(clipboard_x);
		gtk_clipboard_clear(clipboard_gtk);
		gtk_clipboard_set_text(clipboard_x, fontname, -1);
		gtk_clipboard_set_text(clipboard_gtk, fontname, -1);
	end;

	procedure CloseWindow(dialog: pGtkDialog; arg1: gInt; user_data: gPointer);
	begin
		CopyToClipboard;
		gtk_main_quit;
	end;

begin
	gtk_init(@argc, @argv);

	clipboard_x := gtk_clipboard_get(GDK_SELECTION_PRIMARY);
	clipboard_gtk := gtk_clipboard_get(GDK_SELECTION_CLIPBOARD);
	fontdialog := gtk_font_selection_dialog_new(PgChar('gFontSel'));
	gtk_font_selection_dialog_set_preview_text(GTK_FONT_SELECTION_DIALOG(fontdialog), PgChar('The quick brown fox jumps over the lazy dog'));

	g_signal_connect(fontdialog, 'destroy', G_CALLBACK(@gtk_main_quit), nil);
	g_signal_connect(fontdialog, 'response', G_CALLBACK(@CloseWindow), nil);
	
	gtk_widget_show_all(fontdialog);

	gtk_main;
end.

