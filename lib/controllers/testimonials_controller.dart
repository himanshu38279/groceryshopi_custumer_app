import 'package:flutter/cupertino.dart';
import 'package:tbo_the_best_one/api/repository.dart';
import 'package:tbo_the_best_one/models/testimonial.dart';

class TestimonialsController extends ChangeNotifier {
  List<Testimonial> _testimonials;
  bool testimonialsLoading;

  TestimonialsController() {
    _testimonials = [];
    testimonialsLoading = true;
    this.update();
  }

  List<Testimonial> get testimonials => _testimonials ?? [];

  Future<void> update() async {
    await this._updateTestimonials();
  }

  Future<void> _updateTestimonials() async {
    _testimonials = (await Repository.getTestimonials()) ?? [];
    testimonialsLoading = false;
    notifyListeners();
  }
}
