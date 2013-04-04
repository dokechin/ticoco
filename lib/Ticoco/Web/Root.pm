package FormApp::Web::Example;
use Mojo::Base 'Mojolicious::Controller';
use HTML::FillInForm;
use FormValidator::Lite;
use utf8;

# This action will render a template
sub index {
  my $self = shift;

  # Render template "example/welcome.html.ep" with message
  $self->render(
    message => 'Welcome to the Mojolicious real-time web framework!');
}

sub newentry {
  my $self = shift;

  my $validator = FormValidator::Lite->new( $self->req );
  $validator->set_param_message( textinput => '会員番号',);

  $validator->set_message(
        'textinput.not_null' => '[_1] が空です',
        'textinput.uint' => '[_1] が数値でありません');

  my $res = $validator->check(
        textinput => [qw/NOT_NULL UINT/],
    );

  if($validator->has_error) {

     $self->stash->{error_messages} = $validator->get_error_messages();
     $self->stash->{errors} = $validator->errors();
     my $html = $self->render_partial(template => 'example/welcome')->to_string;
     $self->render_text(
            HTML::FillInForm->fill(\$html, $self),
            format => 'html'
     );
  }
   else{
     $self->render(name => $self->param("textinput"));
  }
}
1;
