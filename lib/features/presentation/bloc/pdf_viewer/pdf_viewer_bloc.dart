import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pdf_viewer_event.dart';
part 'pdf_viewer_state.dart';

class PdfViewerBloc extends Bloc<PdfViewerEvent, PdfViewerState> {
  PdfViewerBloc() : super(PdfViewerInitial()) {
    on<PdfViewerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
