class Admin::DisputesController < ApplicationController
    include Pundit::Authorization
    # before_action :set_dispute, only: %i[show update]
    before_action :set_dispute, only: [:show, :update, :transition, :reopen]

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    
    def index
        authorize Dispute, :index?

        @q = params[:q].to_s.strip
        @status = params[:status].to_s.strip

        disputes = policy_scope(Dispute)
        .includes(:charge)
        .in_order_of(:status, %w[open needs_evidence awaiting_decision won lost])
        .order(Arel.sql("disputes.opened_at ASC NULLS LAST, disputes.created_at ASC"))

        disputes = disputes.where(status: @status) if @status.present?
        if @q.present?
            disputes = disputes.joins(:charge).where(
                "disputes.external_id ILIKE :q OR charges.external_id ILIKE :q",
                q: "%#{@q}%"
            )
        end

        @disputes = disputes.limit(10)
    end

    def show
        authorize @dispute, :show?
        @case_actions = @dispute.case_actions.order(created_at: :desc).limit(50)
        @evidence = @dispute.evidence.order(created_at: :desc).limit(50)
    end

    def transition
        authorize @dispute, :transition?

        to = params.require(:to).to_s
        note = params[:note].to_s

        Disputes::Transition.call!( 
        dispute: @dispute,
        actor: current_user,
        to: to,
        note: note
        )

        redirect_to admin_dispute_path(@dispute), notice: "Dispute moved to #{to}."
    rescue ArgumentError => e
        redirect_to admin_dispute_path(@dispute), alert: e.message
    end

    def reopen
        authorize @dispute, :reopen?

        note = params.require(:note).to_s
        Disputes::Reopen.call!(
        dispute: @dispute,
        actor: current_user,
        note: note
        )

        redirect_to admin_dispute_path(@dispute), notice: "Dispute reopened."
    rescue ArgumentError => e
        redirect_to admin_dispute_path(@dispute), alert: e.message
    end

    def set_dispute
        @dispute = Dispute.find(params[:id])
    end

    def queue_order_sql
        <<~SQL.squish
        CASE disputes.status
            WHEN 'open' THEN 1
            WHEN 'needs_evidence' THEN 2
            WHEN 'awaiting_decision' THEN 3
            WHEN 'won' THEN 4
            WHEN 'lost' THEN 5
            ELSE 99
        END ASC,
        disputes.opened_at ASC NULLS LAST,
        disputes.created_at ASC
        SQL
    end

    def approve
        authorize @dispute, :approve?
        @dispute.approve!
    end

    def update
        authorize @dispute

        if @dispute.update(dispute_params)
            redirect_to admin_dispute_path(@dispute),
                        notice: "Dispute updated successfully."
        else
            flash.now[:alert] = "Failed to update dispute."
            render :show, status: :unprocessable_entity
        end
    end

    def dispute_params
        params.require(:dispute).permit(:status, :notes)
    end

    def user_not_authorized
    redirect_to admin_disputes_path, alert: "Not authorized."
  end
end
