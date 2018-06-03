# -*- encoding : utf-8 -*-
# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do

  User.class_eval do
    has_one :tunisian_law, :dependent => :destroy,
                          :validate => true,
                          :autosave => true

    accepts_nested_attributes_for :tunisian_law

    validates :terms,
              :acceptance => {
                :message => _('Please accept the Terms and Conditions'),
                :on => :create,
                :allow_nil => false
              }

    validates :tunisian_law,
              :presence => {
                :message => _('Please enter your General Law information')
              }

    validates :name,
              :format => {
                :with => /\s/,
                :message => _("Please enter your full name - it is required by law when making a request"),
                :allow_blank => true
              }


    after_save :update_censor_rules

    # The "internal admin" is a special user for internal use.
    def self.internal_admin_user
        user = User.find_by_email(AlaveteliConfiguration::contact_email)
        if user.nil?
            password = PostRedirect.generate_random_token
            user = User.new(
                :name => 'Internal admin user',
                :email => AlaveteliConfiguration.contact_email,
                :password => password,
                :password_confirmation => password,
                :terms => '1',
                :tunisian_law_attributes => {
                  :person_status => 'unknown',
				  :postal_addresse => 'unknown'
                }
            )
            user.save!
        end

        user
    end

    private

    def update_censor_rules
      censor_rules.where(:text => identity_card_number).first_or_create(
        :text => identity_card_number,
        :replacement => _('REDACTED'),
        :last_edit_editor => THEME_NAME,
        :last_edit_comment => _('Updated automatically after_save')
      )
    end

  end

  InfoRequest.class_eval do

      def extension_days
          10
      end

      def waiting_response?
          described_state == "waiting_response" || described_state == "deadline_extended"
      end

      def has_extended_deadline?
          info_request_events.any?{ |event| event.described_state == 'deadline_extended' }
      end

      def reply_late_after_days
          if has_extended_deadline?
              AlaveteliConfiguration::reply_late_after_days + extension_days
          else
              AlaveteliConfiguration::reply_late_after_days
          end
      end

      def reply_very_late_after_days
          if has_extended_deadline?
              AlaveteliConfiguration::reply_very_late_after_days + extension_days
          else
              AlaveteliConfiguration::reply_very_late_after_days
          end
      end

      def date_response_required_by
          Holiday.due_date_from(date_initial_request_last_sent_at,
                                reply_late_after_days,
                                AlaveteliConfiguration::working_or_calendar_days)
      end

      def date_very_overdue_after
          Holiday.due_date_from(date_initial_request_last_sent_at,
                                reply_very_late_after_days,
                                AlaveteliConfiguration::working_or_calendar_days)
      end

  end

end
