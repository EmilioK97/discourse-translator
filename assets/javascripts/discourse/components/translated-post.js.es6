import computed from 'ember-addons/ember-computed-decorators';

export default Ember.Component.extend({
  @computed('post.translated_text')
  loading(translated_text) {
    return translated_text === true ? true : false;
  },
});
