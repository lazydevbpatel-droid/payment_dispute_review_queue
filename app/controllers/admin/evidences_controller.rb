class Admin::EvidencesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_dispute

    def create
        authorize @dispute, :transition?

        evidence = @dispute.evidence.new(
        metadata: {
            "description" => params[:text].to_s.presence
        }.compact
        )

        # Attach file if present
        if params[:file].present?
            evidence.file.attach(params[:file])
        end
        
        evidence.save!

        CaseAction.create!(
            dispute: @dispute,
            actor: current_user.email,
            action: "evidence_added",
            details: {
                file_attached: evidence.file.attached?
            }
        )

        redirect_to admin_dispute_path(@dispute), notice: "Evidence attached."
    rescue ActiveRecord::RecordInvalid => e
        redirect_to admin_dispute_path(@dispute), alert: e.record.errors.full_messages.to_sentence
    end

  private

  def set_dispute
    @dispute = Dispute.find(params[:dispute_id])
  end
end
