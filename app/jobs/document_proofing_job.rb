class DocumentProofingJob < ApplicationJob
  queue_as :default

  def perform(result_id:, encrypted_arguments:, trace_id:,
              liveness_checking_enabled:)
    decrypted_args = JSON.parse(
      Encryption::Encryptors::SessionEncryptor.new.decrypt(encrypted_arguments),
      symbolize_names: true,
    )[:document_arguments]

    result = Idv::Proofer.document_job_class.new(
      encryption_key: decrypted_args[:encryption_key],
      front_image_iv: decrypted_args[:front_image_iv],
      back_image_iv: decrypted_args[:back_image_iv],
      selfie_image_iv: decrypted_args[:selfie_image_iv],
      front_image_url: decrypted_args[:front_image_url],
      back_image_url: decrypted_args[:back_image_url],
      selfie_image_url: decrypted_args[:selfie_image_url],
      liveness_checking_enabled: liveness_checking_enabled,
      logger: logger,
      trace_id: trace_id,
    ).proof

    document_result = result.to_h.fetch(:document_result, {})

    dcs = DocumentCaptureSession.new(result_id: result_id)

    dcs.store_doc_auth_result(
      result: document_result.except(:pii_from_doc),
      pii: document_result[:pii_from_doc],
    )
  end
end
